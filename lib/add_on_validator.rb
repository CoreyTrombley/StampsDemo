class AddOnValidator < ActiveModel::Validator
  def validate(o)
    # unless o.name.starts_with? 'X'
    #   o.errors[:name] << 'Need a name starting with X please!'
    # end

    if o.rate
 	  	# Find all of the add ons in the rate
      o.rate[:add_ons][:add_on_v4].each do |add_on|
        if add_on[:requires_all_of] 
          if add_on[:requires_all_of][:requires_one_of][:add_on_type_v4].include?('US-A-COD')
            #
          else
          # do something
          o.errors[:add_ons] << "You must include one of the following codes: #{add_on[:requires_all_of][:requires_one_of][:add_on_type_v4]}"
          end
        elsif add_on[:prohibited_with_any_of][:add_on_type_v4].include?('SOME-BULLSHIT')
          o.errors[:add_ons] << "You can not include any of the following codes: #{add_on[:prohibited_with_any_of][:add_on_type_v4]}"
        end
      end
     # Find all ind all of the addon v4 keys
      # Find all the require_all_of
     # Find the requires one of
      # For each of the requires_oneof codes in add_on_type_v4
      # Check that the add_on_codes contains the code in question
      # If it doesnt...
      # o.errors[:add_ons] << 'You must include one of the following codes....'

      # o.rate[:add_on][:add_on_v4][:etc][:requires_all_of]
    end
  end
end