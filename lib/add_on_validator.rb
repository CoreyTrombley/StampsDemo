class AddOnValidator < ActiveModel::Validator
  def validate(o)
    # This is an array of codes that we've checked
    o.add_on_codes.each do |c|
      required = o.available_add_ons[c]["required_add_ons"]
      prohibited = o.available_add_ons[c]["prohibited_add_ons"]
      
      if required.present? && (required & o.add_on_codes).blank?
        o.errors[:add_ons] << "You must include one of the following add ons: #{required.map {|r| Stamps::Types::ADD_ONS[r] }.join(", ")}"
      end

      if prohibited.present? && (prohibited & o.add_on_codes).present?
        o.errors[:add_ons] << "You can not include any of the following add ons: #{prohibited.map {|r| Stamps::Types::ADD_ONS[r] }.join(", ")}"
      end
    end
  end
end