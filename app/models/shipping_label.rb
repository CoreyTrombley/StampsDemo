class ShippingLabel < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with AddOnValidator

  belongs_to :from_address, :class_name => 'Address', :foreign_key => :from_address_id
  belongs_to :to_address, :class_name => 'Address', :foreign_key => :to_address_id

  # All the available add ons for the given rate from the API
  attr_accessor :available_add_ons

  # The add on codes the merchant has selected
  attr_writer :add_on_codes
  def add_on_codes
    @add_on_codes || []
  end

  attr_accessible :available_add_ons, :to_address_attributes, :ship_date, 
  :service_type, :insurance_amount, :collect_on_delivery, :add_on_codes, 
  :item, :weight, :label_url, :from_address_attributes 

  accepts_nested_attributes_for :from_address, :to_address

  before_create :make_label

  validate :service_type, :presence => true

  def get_rates
    r = Stamps.get_rates(
      :from_zip_code => self.from_address.zip_code,
      :to_zip_code   => self.to_address.zip_code,
      :weight_lb     => self.weight,
      :ship_date     => self.ship_date,
      :service_type  => self.service_type,
      :package_type  => self.item
    )    
    self.available_add_ons = add_ons_from_rate(r.first)
  end

  def make_label
    # Makes a call to the Stamps API with valid data to create a label
    stamp = Stamps.create!(label_options)
    
    if stamp[:errors]
      stamp[:errors].each do |msg|
        self.errors.add(:service_type, msg)
      end
    else
      self.label_url = stamp[:url]
    end

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
    rate_options = rate_options.merge({:insured_value => self.insurance_amount}) if self.add_on_codes.include? "US-A-INS"
    rate_options = rate_options.merge({:cod_value => self.collect_on_delivery}) if self.add_on_codes.include? "US-A-COD"
    rate_options
  end

  def add_ons_from_rate(rate)
    hash = Hash.new
    rate[:add_ons][:add_on_v4].each do |add_on|
      available = add_on[:add_on_type]
      available = [available] if available.is_a?(String)
      if add_on[:requires_all_of]
        required = add_on[:requires_all_of][:requires_one_of][:add_on_type_v4]
        required = [required] if required.is_a?(String)
      end
      if add_on[:prohibited_with_any_of]
        prohibited = add_on[:prohibited_with_any_of][:add_on_type_v4]
        prohibited = [prohibited] if prohibited.is_a?(String)
      end

      available.each do |code|
        add_on = Hash.new
        add_on["required_add_ons"] = required unless required.blank?
        add_on["prohibited_add_ons"] = prohibited unless prohibited.blank?
        hash[code] = add_on
      end
    end
    hash
  end
end