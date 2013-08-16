Feature: Print Shipping Label

  Scenario: A customer prints a shipping label
    Given I am on the shipping label printing page
      And I choose "USPS Parcel Post" as my service type
      And I request a label for a "Package" weighing "5" from "95673" to "11370"
    When I press "Print Label"
    Then I should see a shipping label

  Scenario: A customer prints a shipping label without specifying service type
    Given I am on the shipping label printing page
      And I request a label for a "Package" weighing "5" from "95673" to "11370"
    When I press "Print Label"
    Then I should not see a shipping label
      And I should see "Please specify a service type"

  Scenario: A customer prints a shipping label without specifying package type
    Given I am on the shipping label printing page
      And I choose "USPS Parcel Post" as my service type
      And I request a label for something weighing "5" from "95673" to "11370"
    When I press "Print Label"
    Then I should not see a shipping label
      And I should see "Please specify a package type"

   Scenario: A customer prints a shipping label without choosing a mandatory add-on
    Given I am on the shipping label printing page
      And I choose "USPS Parcel Post" as my service type
      And I request a label for a "Package" weighing "5" from "95673" to "11370"
    Then I should see only those addons relevant to this service type
    When I press "Print Label"
    Then I should not see a shipping label
      And I should see "You must choose one of the following add-ons: ['SC-A-HP', 'US-A-RRM', 'US-A-INS', 'US-A-CM']"

    Scenario: A customer prints a shipping label and chooses a mandatory add on
      Given I am on the shipping label printing page
        And I choose "USPS Parcel Post" as my service type
        And I choose the "US-A-RRM" addon
        And I request a label for a "Package" weighing "5" from "95673" to "11370"
      When I press "Print Label"
      Then I should see a shipping label