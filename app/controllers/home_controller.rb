class HomeController < ApplicationController
  def index
  
  	@products = Product.all
  
  end

   def browse
  
  	@products = Product.all
  
  end
end
