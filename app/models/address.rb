class Address < ActiveRecord::Base
  attr_accessible :address1, :city, :full_name, :state, :zip_code
end
