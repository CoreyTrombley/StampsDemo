class Address < ActiveRecord::Base
  attr_accessible :address1, :city, :full_name, :state, :zip_code

  has_many :shipping_labels
end
