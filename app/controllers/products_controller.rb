
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
		begin
			@product = Product.find(params[:id])
		rescue
			return render_404
		end
		#content = @product.blob.read
	end

	def download
		@product = Product.find(params[:id])
		if @product.nil?
			return render_404
		end
		content = @product.blob.read
		filename = Pathname.new(@product.blob.inspect).basename.to_s
		disposition = "attachment"
		send_data content, :disposition => disposition 
	end

	def show_public
		begin
			@product = Product.find(params[:id])
		rescue
			return render_404
		end
	end

	def download_public
		begin
			order = Order.find_by :download_code => params[:code]
		rescue
			return render_404
		end
		if @order.nil?
			return render_404
		end
		if order.paid and order.cookie == cookies['_DigitalMarketplace_session']
			product = Product.find( order.product_id )
			content = product.blob.read
			filename = Pathname.new(product.blob.inspect).basename.to_s
			disposition = "attachment"
			send_data content, :disposition => disposition
		else
			render :file => "public/401.html", :status => :unauthorized
		end
	end

	private

	def render_404
		return render :file => 'public/404.html', :status => :not_found
	end
end
