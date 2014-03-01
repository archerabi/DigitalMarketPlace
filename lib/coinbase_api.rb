require 'httparty'
require 'json'

	class CoinbaseApi
		include HTTParty
		def initialize user
	      @user = user
	      @client = get_client
	      @token = OAuth2::AccessToken.new @client, @user.coinbase_access_token, { refresh_token: @user.coinbase_refresh_token }
	      if @user.coinbase_access_token.nil? or @user.coinbase_refresh_token.nil?
	      	authenticate
	      end
	    end


		def create_button name,price,currency,description=nil, custom=nil, options={}
			body = { 
				button: 
				{ 
					name: name,
					price_string: price,
					price_currency_iso: currency
				}
			}
			call :post,'api/v1/buttons', body
		end

		def create_order button_id
			call :post, "api/v1/buttons/#{button_id}/create_order"
		end

		def balance 
			call :get,'api/v1/account/balance'
		end

		def call method_name, url, opts = {} 
			response = nil
			begin
				if method_name.eql? :post
					response = @token.post url,{ body: opts }
				elsif method_name.eql? :get
					response = @token.get url
				end
			rescue OAuth2::Error => e
				puts "Caught Exception #{e.description}"
				puts e
			end
			if response.nil? || response.status != 200
				begin
					refresh_token
					return call method_name, url
				rescue OAuth2::Error => e
					puts "Caught Exception on refresh"
					puts e
					authenticate
				end
			end
			return response
		end

		def authenticate
			redirect_uri = ENV['COINBASE_CALLBACK_URL']
			@client.auth_code.authorize_url(:redirect_uri => redirect_uri)
			@token = @client.auth_code.get_token(@user.coinbase_code, redirect_uri: redirect_uri)
			save_tokens
		end

		def save_tokens
			@user.coinbase_access_token = @token.token
			@user.coinbase_refresh_token = @token.refresh_token
			@user.save
		end

		def refresh_token
			@token.refresh!	
			save_tokens
		end

		def get_client
			client = OAuth2::Client.new(ENV['COINBASE_CLIENT_ID'], ENV['COINBASE_CLIENT_SECRET'], site: 'https://coinbase.com')
			return client
		end
	end
