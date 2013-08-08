class ShippingRate < ActiveRecord::Base
  attr_accessible :from_zip_code, :package_type, :service_type, :ship_date, :to_zip_code, :weight, :rates

  before_create :get_rates

  def get_rates
    rates = Stamps.get_rates(
      :from_zip_code => self.from_zip_code,
      :to_zip_code   => self.to_zip_code,
      :weight_lb     => self.weight,
      :ship_date     => self.ship_date,
      :service_type  => self.service_type,
      :package_type  => self.package_type
    )

    self.rates = rates
  end
end
