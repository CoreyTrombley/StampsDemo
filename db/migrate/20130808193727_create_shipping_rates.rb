class CreateShippingRates < ActiveRecord::Migration
  def change
    create_table :shipping_rates do |t|
      t.string :from_zip_code
      t.string :to_zip_code
      t.float :weight
      t.date :ship_date
      t.string :service_type
      t.string :package_type

      t.timestamps
    end
  end
end
