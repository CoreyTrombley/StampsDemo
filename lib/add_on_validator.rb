class AddOnValidator < ActiveModel::Validator
  def validate(o)
    # This is an array of codes that we've checked
    # o.add_on_codes.each do |c|
    # if o.rate
    #   o.rate[:add_ons][:add_on_v4].each do |add_on|
    #     if o.add_on_codes.include?(add_on[:add_on_type])
      # if add_on[:requires_all_of]
        # required = add_on[:requires_all_of][:requires_one_of][:add_on_type_v4]
        # TODO: Fix gem to remove line below
        # required = [required] if required.is_a?(String)
        if (o.required_add_ons & o.add_on_codes).blank?
          o.errors[:add_ons] << "You must include one of the following codes: #{required}"
        end
      # end

      # if add_on[:prohibited_with_any_of]
        # prohibited = add_on[:prohibited_with_any_of][:add_on_type_v4]
        if (o.prohibited_add_ons & o.add_on_codes).present?
          o.errors[:add_ons] << "You can not include any of the following codes: #{prohibited}"
        end
      # end
    #     end
    #   end
    # end
  end
end