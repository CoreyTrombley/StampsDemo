class AddLabelUrlToShippingLabel < ActiveRecord::Migration
  def change
    add_column :shipping_labels, :label_url, :string
  end
end
