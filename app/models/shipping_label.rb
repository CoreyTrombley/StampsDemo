class ShippingLabel < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with AddOnValidator

  belongs_to :from_address, :class_name => 'Address', :foreign_key => :from_address_id
  belongs_to :to_address, :class_name => 'Address', :foreign_key => :to_address_id
  belongs_to :shipping_rate #TODO - Make a model called ShippingRate


  attr_accessor :rate
  # Need to persist that in the case of failed validation....
  attr_accessor :available_add_ons
  attr_accessor :required_add_ons
  attr_accessor :prohibited_add_ons

  attr_writer :add_on_codes

  def add_on_codes
    @add_on_codes || []
  end
  attr_accessible :prohibited_add_ons, :required_add_ons, :available_add_ons
  attr_accessible :from, :item, :to, :weight, :label_url, :from_address_attributes, :to_address_attributes, :ship_date, :service_type, :insurance_amount, :collect_on_delivery, :add_on_codes

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
    self.rate = rates.first
    self.prohibited_add_ons = prohibited_addons
    self.required_add_ons = required_addons
    self.available_add_ons = available_addons

  end

  def make_label

    # Makes a call to the Stamps API with valid data to create a label
    stamp = Stamps.create!(label_options)

    # Saves the label url in the data base.
    # if stamp[:errors]
    stamp[:errors].each do |msg|
      self.errors.add(:service_type, msg)
    end
    # else
    self.label_url = stamp[:url]
    # end

    return self.errors.empty?
  end

  private
  def label_options
    {
      :transaction_id  => Time.now.strftime("%m%d%Y%I%M%S"),
      :tracking_number => true,
      :to => {
        :full_name          => self.to_address.full_name,
        :address1           => self.to_address.address1,
        :city               => self.to_address.city,
        :state              => self.to_address.state,
        :zip_code           => self.to_address.zip_code
      },
      :from => {
        :full_name          => self.from_address.full_name,
        :address1           => self.from_address.address1,
        :city               => self.from_address.city,
        :state              => self.from_address.state,
        :zip_code           => self.from_address.zip_code
      },
      :rate => {
        :from_zip_code => self.from_address.zip_code,
        :to_zip_code   => self.to_address.zip_code,
        :weight_lb     => self.weight,
        :ship_date     => self.ship_date,
        :service_type  => self.service_type,
        :package_type  => self.item
      }.merge(rate_options)
    }
  end

  def rate_options
    rate_options = {
      :add_ons => {
        :add_on_v4 => self.add_on_codes.map {|code| { :add_on_type => code } }
      }
    }

    # Change this to be something else...
    we_ve_checked_the_box = true
    rate_options = rate_options.merge({:insured_value => self.insurance_amount}) if we_ve_checked_the_box
    # rate_options.merge({:cod_value => self.collect_on_delivery}) if we_ve_checked_the_box
    rate_options
  end

  def available_addons
    array = []
    rate[:add_ons][:add_on_v4].each do |add_on|
      available = add_on[:add_on_type]
      available = [available] if available.is_a?(String)
      available.each do |code|
        array << code
      end
    end
    array
  end
  def required_addons
    array = []
    rate[:add_ons][:add_on_v4].each do |add_on|
      if add_on[:requires_all_of]
        required = add_on[:requires_all_of][:requires_one_of][:add_on_type_v4]
        required = [required] if required.is_a?(String)
        required.each do |code|
          array << code
        end
      end
    end
    array.uniq!
  end
  def prohibited_addons
    array = []
    rate[:add_ons][:add_on_v4].each do |add_on|
      if add_on[:prohibited_with_any_of]
        prohibited = add_on[:prohibited_with_any_of][:add_on_type_v4]
        prohibited = [prohibited] if prohibited.is_a?(String)
        prohibited.each do |code|
          array << code
        end
      end
    end
    array.uniq!
  end
end
