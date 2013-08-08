class ShippingLabel < ActiveRecord::Base
  belongs_to :from_address, :class_name => 'Address', :foreign_key => :from_address_id
  belongs_to :to_address, :class_name => 'Address', :foreign_key => :to_address_id
  belongs_to :shipping_rate #TODO - Make a model called ShippingRate

  attr_accessible :from, :item, :to, :weight, :label_url, :from_address_attributes, :to_address_attributes, :ship_date, :service_type

  accepts_nested_attributes_for :from_address, :to_address

  before_create :make_label

  validate :shipping_rate, :presence => true

  def make_label
    rates = Stamps.get_rates(
      :from_zip_code => self.from_address.zip_code,
      :to_zip_code   => self.to_address.zip_code,
      :weight_lb     => self.weight,
      :ship_date     => self.ship_date,
      :service_type  => self.service_type,
      :package_type  => self.item
    )

    stamp = Stamps.create!({
    :transaction_id  => "RANDOM_STRING",
    :tracking_number => true,
    :to => {
      :full_name   => self.to_address.full_name,
      :address1    => self.to_address.address1,
      :city        => self.to_address.city,
      :state       => self.to_address.state,
      :zip_code    => self.to_address.zip_code
    },
    :from => {
      :full_name   => self.from_address.full_name,
      :address1    => self.from_address.address1,
      :city        => self.from_address.city,
      :state       => self.from_address.state,
      :zip_code    => self.from_address.zip_code
    },
    :rate          => {
      :from_zip_code => self.from_address.zip_code,
      :to_zip_code   => self.to_address.zip_code,
      :weight_oz     => self.weight,
      :ship_date     => self.ship_date,
      :package_type  => self.item,
      :service_type  => self.service_type,
      :cod_value     => 10.00,
      :add_ons       => {
        :add_on => [
          { :type => 'US-A-COD' },
          { :type => 'US-A-DC' }
        ]
      }
    }
  }
)

    self.label_url = stamp.url
  end
end
