Feature: Print Shipping Label
  Scenario: A customer prints a shipping label
    Given I am on the shipping label printing page
      And I choose "USPS Parcel Select" as my service type
      And I request a label for a "Package" weighing "5" from "95673" to "11370"
      And I choose the "US-A-SC" addon
      And I choose the "US-A-RR" addon
      And I choose the "US-A-CM" addon
    When I press "Print Label"
    Then I should see a shipping label
   @javascript
   Scenario: A customer prints a shipping label without choosing a mandatory add-on
    Given I am on the shipping label printing page
      And I choose "USPS Parcel Select" as my service type
      And I request a label for a "Package" weighing "5" from "London, OH" to "Birmingham, AL"
      And I choose the "US-A-SC" addon
    # Then I should see only those addons relevant to this service type
    When I press "Print Label"
    Then I should not see a shipping label
      And I should see "You must choose one of the following add-ons: ['SC-A-HP', 'US-A-RRM', 'US-A-INS', 'US-A-CM']"

    @wip
    Scenario: A customer prints a shipping label and chooses a mandatory add on
      Given I am on the shipping label printing page
        And I choose "USPS Parcel Select" as my service type
        And I choose the "US-A-RRM" addon
        And I choose the "US-A-SC" addon
        And I request a label for a "Package" weighing "5" from "London, OH" to "Birmingham, AL"
      When I press "Print Label"
      Then I should see a shipping label