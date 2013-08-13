class AddToAndFromAddressIdToShippingLabels < ActiveRecord::Migration
  def change
    add_column :shipping_labels, :from_address_id, :integer
    add_column :shipping_labels, :to_address_id, :integer
  end
end
