class ShippingLabel < ActiveRecord::Base
  belongs_to :from_address, :class_name => 'Address', :foreign_key => :from_address_id
  belongs_to :to_address, :class_name => 'Address', :foreign_key => :to_address_id
  belongs_to :shipping_rate #TODO - Make a model called ShippingRate

  attr_accessible :from, :item, :to, :weight, :label_url, :from_address_attributes, :to_address_attributes, :ship_date, :service_type

  accepts_nested_attributes_for :from_address, :to_address

  before_create :make_label

  validate :shipping_rate, :presence => true

  def make_label
    ####################################################
    # Currently is not needed as the information they  #
    # provide gets the rate needed. If we want to show #
    # rates this can me used, but will add a step for  #
    # the user.                                        #
    ####################################################
    # rates = Stamps.get_rates(
    #   :from_zip_code => self.from_address.zip_code,
    #   :to_zip_code   => self.to_address.zip_code,
    #   :weight_lb     => self.weight,
    #   :ship_date     => self.ship_date,
    #   :service_type  => self.service_type,
    #   :package_type  => self.item
    # )
    ####################################################


    # Makes a call to the Stamps API with valid data to create a label
    stamp = Stamps.create!({
    :transaction_id  => Time.now.strftime("%m%d%Y%I%M%S"),
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
      :service_type  => self.service_type
      #:cod_value     => 10.00,
      # :add_ons       => {
      #   :add_on => [
      #     { :type => 'US-A-COD' },
      #     { :type => 'US-A-DC' }
      #   ]
      # }
    }
  }
)
    # Saves the label url in teh data base.
    # TODO: look up how long label urls last.
    if stamp[:errors] != nil
      stamp[:errors].each do |msg|
        self.errors.add(:service_type, msg)
      end
      binding.pry
    end
    if stamp[:url] != nil 
      self.label_url = stamp[:url]
    end
  end
end
