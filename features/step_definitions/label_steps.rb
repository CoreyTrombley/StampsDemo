Given /^I am on the shipping label printing page$/ do
  # Update the routes so that the homepage goes to the shipping label page for now
  visit('/')
end

Given /^I request a label for a "(.*?)" weighing "(.*?)" from "(.*?)" to "(.*?)"$/ do |product, weight, from, to|
  fill_in "Item", :with => product
  fill_in "Weight", :with => weight
  fill_in "From Address", :with => from
  fill_in "To Address", :with => to
end

When /^I press "(.*?)"$/ do |value|
  click_button value
end

Then /^I should see a shipping label$/ do
  # TODO - tricky one to test.... will have a URL in the page, perhaps output it
  # somewhere on the view for now, and have a regexp to see that there is an image
  # in a box or somthing...
  assert page.has_content?('img#shipping_label')
end
