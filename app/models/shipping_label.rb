class ShippingLabel < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with AddOnValidator

  belongs_to :from_address, :class_name => 'Address', :foreign_key => :from_address_id
  belongs_to :to_address, :class_name => 'Address', :foreign_key => :to_address_id
  belongs_to :shipping_rate #TODO - Make a model called ShippingRate

  attr_writer :add_on_codes

  def add_on_codes
    @add_on_codes || []
  end

  attr_accessible :from, :item, :to, :weight, :label_url, :from_address_attributes, :to_address_attributes, :ship_date, :service_type, :insurance_ammount, :collect_on_delivery, :add_on_codes

  accepts_nested_attributes_for :from_address, :to_address

  before_create :make_label

  validate :shipping_rate, :presence => true
  validate :service_type, :presence => true

  def get_rates
    rates = Stamps.get_rates(
      :from_zip_code => self.from_address.zip_code,
      :to_zip_code   => self.to_address.zip_code,
      :weight_lb     => self.weight,
      :ship_date     => self.ship_date,
      :service_type  => self.service_type,
      :package_type  => self.item
    )
    rates.first
  end

  def make_label
    # Makes a call to the Stamps API with valid data to create a label
    opts = {
      :transaction_id  => Time.now.strftime("%m%d%Y%I%M%S"),
      :tracking_number => true,
      :to               => {
        :full_name          => self.to_address.full_name,
        :address1           => self.to_address.address1,
        :city               => self.to_address.city,
        :state              => self.to_address.state,
        :zip_code           => self.to_address.zip_code
      },
      :from             => {
        :full_name          => self.from_address.full_name,
        :address1           => self.from_address.address1,
        :city               => self.from_address.city,
        :state              => self.from_address.state,
        :zip_code           => self.from_address.zip_code
      },
      :rate =>  get_rates.merge(:add_ons => {
        :add_on_v4 => self.add_on_codes.map {|code| { :add_on_type => code } }
      })
      # :rate             => {
      #   :from_zip_code      => self.from_address.zip_code,
      #   :to_zip_code        => self.to_address.zip_code,
      #   :weight_oz          => self.weight,
      #   :ship_date          => self.ship_date,
      #   :package_type       => self.item,
      #   :service_type       => self.service_type,

      #   # ALERT: These may need to be integers
      #   # :insurance_ammount  => self.insurance_ammount,
      #   # :cod_value          => self.collect_on_delivery
      #   :add_ons => {
      #     :add_on_v4 => self.add_on_codes.map {|code| { :add_on_type => code } }
      #   }
      # }
    }

    stamp = Stamps.create!(opts)

    # Saves the label url in the data base.

    if stamp[:errors]
      stamp[:errors].each do |msg|
        self.errors.add(:service_type, msg)
      end
    else
      self.label_url = stamp[:url]
    end

    return self.errors.empty?
  end
end
