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
      @label.available_add_ons = { 
      	"US-A-RR" => { 
      		"required_add_ons" => ["US-A-COD", "US-A-REG", "US-A-CM", "US-A-INS"], 
      		"prohibited_add_ons" => ["SC-A-HP", "US-A-RRM"] 
      	},
      	"US-A-COD" => { 
      		"required_add_ons" => ["US-A-REG", "US-A-RR"],
      		"prohibited_add_ons" => ["SC-A-HP"]
      	},
      	"US-A-RRM" => {}
      }
    end

    context "when choosing the US-A-RR add-on" do
	    it "should accept a required add on e.g. US-A-COD" do
	    	@label.add_on_codes = ['US-A-COD', 'US-A-RR']
	    	@label.valid?.should be_true
	    end

	    it "should not accept a prohibited add on" do
	    	@label.add_on_codes = ['US-A-RRM', 'US-A-RR']
	    	@label.valid?.should be_false
	    end
	  end
  end
end