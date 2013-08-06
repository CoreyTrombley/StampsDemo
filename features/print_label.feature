Feature: Print Shipping Label

  Scenario: A customer prints a shipping label
    Given I am on the shipping label printing page
      And I request a label for a "Turnip" weighing "50lbs" from "London, OH" to "Birmingham, AL"
    When I press "Print Label"
    Then I should see a shipping label