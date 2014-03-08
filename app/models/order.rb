class Order
  include Mongoid::Document
  belongs_to :product

  field :coinbase_id, type: String
  field :address, type: String
  field :cookie, type: String
  field :download_code, type:String
  field :paid, type: Boolean, default: false
  field :btc_price, type: Float
end
