
require 'coinbase_api'

class ProductsController < ApplicationController
	before_filter :authenticate_user! , :except => [:show_public, :download_public]

	def new
		
	end

	def create	
		@product = Product.new(params[:product])
		@product.user_id = current_user.id
		if @product.save
			return redirect_to @product
		end
		flash[:error] = @product.errors.full_messages.join("<br>").html_safe
		redirect_to "/products/new"
	end

	def show
		@product = Product.find(params[:id])
		#content = @product.blob.read
	end

	def download
		@product = Product.find(params[:id])
		content = @product.blob.read
		filename = Pathname.new(@product.blob.inspect).basename.to_s
		disposition = "attachment; filename='#{filename}'"
		send_data content, :disposition=> disposition, :filename => filename
	end

	def show_public
		@product = Product.find(params[:id])
	end

	def download_public
		order = Order.find_by :download_code => params[:code]
		if order.paid and order.cookie == cookies['_DigitalMarketplace_session']
			product = Product.find( order.product_id )
			content = product.blob.read
			filename = Pathname.new(product.blob.inspect).basename.to_s
			disposition = "attachment; filename='#{filename}'"
			send_data content, :disposition=> disposition, :filename => filename
		else
			render :file => "public/401.html", :status => :unauthorized
		end
	end
end
