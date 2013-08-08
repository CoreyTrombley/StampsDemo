class AddServiceTypeToShippingLabel < ActiveRecord::Migration
  def change
    add_column :shipping_labels, :service_type, :string
  end
end
