class ShippingLabel < ActiveRecord::Base
  attr_accessible :from, :item, :to, :weight
end
