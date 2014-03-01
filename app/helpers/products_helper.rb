module ProductsHelper

	def get_balance
		begin
			coinbase = CoinbaseApi.new current_user
			coinbase.balance.parsed
		rescue Exception => e
			puts 'Exception Caught'
			puts e
			current_user.coinbase_code = nil
			current_user.coinbase_access_token = nil
			current_user.coinbase_refresh_token = nil
			current_user.save
		end
	end

	def get_button
		begin
			coinbase = CoinbaseApi.new current_user
			response = coinbase.create_button 'Test Button', '234.3', 'USD'
			button_code = response.parsed['button']['code']
			response = coinbase.create_order button_code
			response.parsed.to_s
		rescue Exception => e
			puts 'Exception Caught'
			puts e
			current_user.coinbase_code = nil
			current_user.coinbase_access_token = nil
			current_user.coinbase_refresh_token = nil
			current_user.save
		end
	end

	def connect_to_coinbase_visible?
		current_user.coinbase_access_token.nil? or current_user.coinbase_refresh_token.nil? or current_user.coinbase_code.nil?
	end
end
