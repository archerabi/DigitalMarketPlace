class ProductBlob
	include Mongoid::Document
	
	has_mongoid_attached_file :image
end
