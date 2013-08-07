class CreateShippingLabels < ActiveRecord::Migration
  def change
    create_table :shipping_labels do |t|
      t.string :url

      t.timestamps
    end
  end
end
