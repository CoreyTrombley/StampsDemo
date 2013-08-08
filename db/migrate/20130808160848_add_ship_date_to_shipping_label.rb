class AddShipDateToShippingLabel < ActiveRecord::Migration
  def change
    add_column :shipping_labels, :ship_date, :date
  end
end
