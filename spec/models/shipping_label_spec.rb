require 'spec_helper'

describe ShippingLabel do
	before do
    @label = ShippingLabel.new
  end

  it "should have hidden postage costs add on by default" do
    @label.add_on_codes = [{ :type => 'SC-A-HP' }]
  end

  describe "Validating add ons" do
    before do
      @label.rate = {:from_zip_code=>"11370",
			 :to_zip_code=>"95673",
			 :amount=>"0.33",
			 :service_type=>"US-FC",
			 :deliver_days=>"3",
			 :weight_lb=>"1",
			 :package_type=>"Postcard",
			 :ship_date=>"2013-08-15",
			 :non_machinable=>true,
			 :dim_weighting=>"N",
			 :add_ons=>
			  {:add_on_v4=>
			    [{:add_on_type=>"US-A-INS",
			      :prohibited_with_any_of=>
			       {:add_on_type_v4=>
			         ["SC-A-HP", "US-A-REG", "US-A-CM", "US-A-COD", "SC-A-INS"]},
			      :missing_data=>"InsuredValue"},
			     {:add_on_type=>"US-A-COD",
			      :prohibited_with_any_of=>
			       {:add_on_type_v4=>["SC-A-HP", "US-A-RRM", "US-A-INS", "US-A-CM"]},
			      :missing_data=>"CODValue"},
			     {:amount=>"2.55",
			      :add_on_type=>"US-A-RR",
			      :requires_all_of=>
			       {:requires_one_of=>
			         {:add_on_type_v4=>["US-A-COD", "US-A-REG", "US-A-CM", "US-A-INS"]}},
			      :prohibited_with_any_of=>{:add_on_type_v4=>["SC-A-HP", "US-A-RRM"]}},
			     {:amount=>"11.2",
			      :add_on_type=>"US-A-REG",
			      :prohibited_with_any_of=>
			       {:add_on_type_v4=>
			         ["SC-A-HP", "US-A-CM", "US-A-INS", "US-A-RRM", "SC-A-INS"]}},
			     {:amount=>"4.75",
			      :add_on_type=>"US-A-RD",
			      :requires_all_of=>
			       {:requires_one_of=>
			         {:add_on_type_v4=>["US-A-COD", "US-A-REG", "US-A-CM", "US-A-INS"]}},
			      :prohibited_with_any_of=>{:add_on_type_v4=>["SC-A-HP", "US-A-RRM"]}},
			     {:add_on_type=>"SC-A-INS",
			      :prohibited_with_any_of=>{:add_on_type_v4=>["US-A-REG", "US-A-INS"]},
			      :missing_data=>"InsuredValue"},
			     {:amount=>"4.15",
			      :add_on_type=>"US-A-NND",
			      :requires_all_of=>{:requires_one_of=>{:add_on_type_v4=>"US-A-COD"}}}]},
			 :effective_weight_in_ounces=>"16",
			 :zone=>"8",
			 :rate_category=>"286785536",
			 :to_state=>"CA"
			}
    end

    context "when choosing the US-A-RR add-on" do
	    it "should accept a valid add on e.g. US-A-COD" do
	    	@label.add_on_codes = ['US-A-COD', 'US-A-RR']
	    	@label.valid?.should be_true
	    end

	    it "should not accept any bullshit" do
	    	@label.add_on_codes = ['SOME-BULLSHIT', 'US-A-RR']
	    	@label.valid?.should be_false
	    end
	  end
  end
end