class AddRatesToShippingRates < ActiveRecord::Migration
  def change
    add_column :shipping_rates, :rates, :text
  end
end
