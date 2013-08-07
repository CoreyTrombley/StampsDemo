class CreateShippingLabels < ActiveRecord::Migration
  def change
    create_table :shipping_labels do |t|
      t.string :item
      t.string :weight
      t.string :from
      t.string :to

      t.timestamps
    end
  end
end
