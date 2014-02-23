
class ProductsController < ApplicationController
	def new
		puts "********"
		# binding.pry
	end

	def create	
		@product = Product.new(params[:product])
		# # @product.productblob.build

		if @product.save
			puts '****** Success ********'
			redirect_to @product
		else
			puts '****** Failed ********'
			@product.errors.each { |k, v| errors << v }
			puts @product.errors
			@product = errors.join("\n")
			respond_to do |format|
				format.html { render :new }
				format.js
			end
		end
	end

	def show
		@product = Product.find(params[:id])
		#content = @product.blob.read
	end

	def serve
		gridfs_path = env["PATH_INFO"].gsub("/images/", "")
		begin
			gridfs_file = Mongo::GridFileSystem.new(Mongoid.database).open(gridfs_path, 'r')
			self.response_body = gridfs_file.read
			self.content_type = gridfs_file.content_type
		rescue
			self.status = :file_not_found
			self.content_type = 'text/plain'
			self.response_body = ''
		end
	end
end
