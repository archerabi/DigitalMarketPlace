require 'coinbase_api'
require 'net/http'
require 'json'

class OrdersController < ApplicationController

	def create
		puts "Params #{params}"
		product = Product.find(params[:product_id])
		user = User.find(product.user_id)
		coinbase = CoinbaseApi.new user
		begin
			response = coinbase.create_order(product.name, product.price, 'USD')
			order = Order.new product: product.id
			order.coinbase_id = response.parsed['order']['id']
			order.address = response.parsed['order']['receive_address']
			order.cookie = cookies['_DigitalMarketplace_session']
			response = coinbase.sell_price_of_btc
			order.btc_price = product.price.to_f / response.parsed['subtotal']['amount'].to_f
			order.btc_price = order.btc_price.round(8) # bitcoin subunit if 10^-8
			order.save
			render :json => { order: { id: order.id , receive_address: order.address, btc_price: order.btc_price}}
		rescue OAuth2::Error => e
			puts e
		end
	end

	def get
		order = Order.find_by coinbase_id: params[:id]
		product = Product.find(order.product_id)
		user = User.find(product.user_id)
		coinbase = CoinbaseApi.new user
		response = coinbase.get_order order.coinbase_id
		render :json => response.parsed
	end

	def order_status
		order = Order.find params[:id]
		response = Net::HTTP.get(URI("http://blockchain.info/address/#{order.address}?format=json"))
		response = JSON.load(response)
		product = Product.find order.product_id
		if order.btc_price.to_f <= response['final_balance'].to_f
			order.paid = true
			order.save
		end
		render :json => { balance: response['final_balance'], paid: order.paid }
	end

	def download_code
		order = Order.find params[:id]
		if order.paid and order.cookie == cookies['_DigitalMarketplace_session']
			order.download_code = SecureRandom.hex 16
			order.save
			return render :json => { success: true, code: order.download_code }
		end
		render :json => { success: false}
	end

end
