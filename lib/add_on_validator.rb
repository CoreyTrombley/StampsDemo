class AddOnValidator < ActiveModel::Validator
  def validate(o)
    if o.rate
      o.rate[:add_ons][:add_on_v4].each do |add_on|
        if add_on[:requires_all_of] || add_on[:prohibited_with_any_of]
          if add_on[:requires_all_of]
            required = add_on[:requires_all_of][:requires_one_of][:add_on_type_v4]
            if required.class == String
              array = []
              array << required
              required = array
            end
            if (required & o.add_on_codes)
              if (required & o.add_on_codes).empty?
                o.errors[:add_ons] << "You must include one of the following codes: #{required}"
              end
            end
          end
          if add_on[:prohibited_with_any_of]
            prohibited = add_on[:prohibited_with_any_of][:add_on_type_v4]
            if (prohibited & o.add_on_codes)
              if (prohibited & o.add_on_codes).present?
                o.errors[:add_ons] << "You can not include any of the following codes: #{prohibited}"
              end
            end
          end
        end
      end
    end
  end
end