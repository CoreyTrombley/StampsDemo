class ShippingLabel < ActiveRecord::Base
  belongs_to :from_address, :class_name => 'Address', :foreign_key => :from_address_id
  belongs_to :to_address, :class_name => 'Address', :foreign_key => :to_address_id
  belongs_to :shipping_rate #TODO - Make a model called ShippingRate

  attr_accessible :from, :item, :to, :weight, :label_url, :from_address_attributes, :to_address_attributes, :ship_date

  accepts_nested_attributes_for :from_address, :to_address

  before_create :make_label

  validate :shipping_rate, :presence => true

  def make_label
    rates = Stamps.get_rates(
      :from_zip_code => '45440',
      :to_zip_code   => '20500',
      :weight_lb     => '0.5',
      :ship_date     => self.ship_date
    )

    stamp = Stamps.create!({
    :transaction_id  => "RANDOM_STRING",
    :tracking_number => true,
    :to => {
      #:full_name   => this.from_address.full_name,
      :full_name   => 'Corey Trombley',
      :address1    => '3025 81st street',
      :city        => 'East Elmhurst',
      :state       => 'NY',
      :zip_code    => '11370'
    },
    :from => {
      :full_name   => 'Littlelines',
      :address1    => '50 Chestnut Street',
      :address2    => 'Suite 234',
      :city        => 'Beavervcreek',
      :state       => 'OH',
      :zip_code    => '45440'
    },
    :rate          => {
      :from_zip_code => '45440',
      :to_zip_code   => '11370',
      :weight_oz     => this.weight,
      :ship_date     => Date.today.strftime('%Y-%m-%d'),
      :package_type  => 'Package',
      :service_type  => 'US-FC',
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
