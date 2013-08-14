class AddCodAndInsuranceAmmountToShippingLabels < ActiveRecord::Migration
  def change
    add_column :shipping_labels, :collect_on_delivery, :string
    add_column :shipping_labels, :insurance_ammount, :string
  end
end
