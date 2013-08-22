@javascript
Feature: Print Shipping Label
  
  Scenario: A customer prints a shipping label
    Given I am on the shipping label printing page
      And I choose "USPS Parcel Select" as my service type
      And I request a label for a "Package" weighing "5" from "95673" to "11370"
    Then I should see only those addons relevant to this service type
      And I choose the "US-A-DC" addon
      # And I choose the "US-A-RRE" addon
      # And I choose the "US-A-CM" addon
    When I press "Print Label"
    Then I should see a shipping label

   Scenario: A customer prints a shipping label without choosing a mandatory add-on
    Given I am on the shipping label printing page
      And I choose "USPS Parcel Select" as my service type
      And I request a label for a "Package" weighing "5" from "95673" to "11370"
    Then I should see only those addons relevant to this service type
      And I choose the "US-A-SC" addon
      And I choose the "US-A-RR" addon
    When I press "Print Label"
    Then I should not see a shipping label
      And I should see "Required Add-On was missing for USPS_Return_Receipt"
    
    Scenario: A customer prints a shipping label and chooses a mandatory add on
      Given I am on the shipping label printing page
        And I choose "USPS Parcel Select" as my service type
        And I request a label for a "Package" weighing "5" from "95673" to "11370"
      Then I should see only those addons relevant to this service type
        And I choose the "US-A-DC" addon
        And I choose the "US-A-RRM" addon
        # And I choose the "US-A-SC" addon
      When I press "Print Label"
      Then I should see a shipping label