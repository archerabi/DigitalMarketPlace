class Product
	include Mongoid::Document
	
	belongs_to :user
	mount_uploader :blob, ProductUploader

	validates :name, presence: true, length: { minimum: 5, maximum: 25}
	validates :price, presence: true, :format => { :with => /^\d+??(?:\.\d{0,2})?$/ }, :numericality => {:greater_than => 0, :less_than => 10}
	validates :description, presence: true, length: { minimum: 5, maximum: 250}
end
	