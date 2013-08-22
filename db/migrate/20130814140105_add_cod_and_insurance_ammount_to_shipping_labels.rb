class AddCodAndInsuranceAmmountToShippingLabels < ActiveRecord::Migration
  def change
    add_column :shipping_labels, :collect_on_delivery, :float
    add_column :shipping_labels, :insurance_amount, :float
  end
end
