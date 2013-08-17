class AddOnValidator < ActiveModel::Validator
  def validate(o)
    if o.rate
      o.rate[:add_ons][:add_on_v4].each do |add_on|
        if add_on[:requires_all_of]
          if add_on[:requires_all_of][:requires_one_of][:add_on_type_v4].include?(o.add_on_codes)
            
          else
          o.errors[:add_ons] << "You must include one of the following codes: #{add_on[:requires_all_of][:requires_one_of][:add_on_type_v4]}"
          end
        elsif add_on[:prohibited_with_any_of][:add_on_type_v4].include?(o.add_on_codes)
          o.errors[:add_ons] << "You can not include any of the following codes: #{add_on[:prohibited_with_any_of][:add_on_type_v4]}"
        end
      end
    end
  end
end