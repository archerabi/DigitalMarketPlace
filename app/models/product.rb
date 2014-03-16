class Product
	include Mongoid::Document
	attr_accessor :name, :price, :description
	belongs_to :user
	mount_uploader :blob, ProductUploader
	mount_uploader :preview_image, ImageUploader

	validates :name, presence: true, length: { minimum: 5, maximum: 75}
	validates :price, presence: true, :format => { :with => /^\d{1,4}(\.\d{0,2})?$/ }, :numericality => {:greater_than => 0, :less_than => 10}
	validates :description, presence: true, length: { minimum: 5, maximum: 2000}
	validates :blob, presence: { message: "File required" }
end
	