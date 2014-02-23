class Product
	include Mongoid::Document
	
	mount_uploader :blob, ProductUploader
end
