Given /^I am on the shipping label printing page$/ do
  # Update the routes so that the homepage goes to the shipping label page for now
  visit('/')
end

Given /^I request a label for a "(.*?)" weighing "(.*?)" from "(.*?)" to "(.*?)"$/ do |product, weight, from, to|
  # Package info being entered
  select product
  # From address info being entered
  fill_in "shipping_label[from_address_attributes][zip_code]", :with => from
  fill_in "shipping_label[to_address_attributes][zip_code]", :with => to

  fill_in "shipping_label[from_address_attributes][full_name]", :with => 'Corey Trombley'
  fill_in "shipping_label[from_address_attributes][address1]", :with => '1234 ABD Drive'
  fill_in "shipping_label[from_address_attributes][city]", :with => 'Rio Linda'
  fill_in "shipping_label[from_address_attributes][state]", :with => 'CA'


  # To address info being entered
  fill_in "shipping_label[to_address_attributes][full_name]", :with => 'Elaine Trombley'
  fill_in "shipping_label[to_address_attributes][address1]", :with => '4321 ZYX Place'
  fill_in "shipping_label[to_address_attributes][city]", :with => 'East Elmhurst'
  fill_in "shipping_label[weight]", :with => weight
  fill_in "shipping_label[to_address_attributes][state]", :with => 'NY'
end

When /^I press "(.*?)"$/ do |value|
  click_button value
end

Then /^I should see a shipping label$/ do
  # TODO - tricky one to test.... will have a URL in the page, perhaps output it
  # somewhere on the view for now, and have a regexp to see that there is an image
  # in a box or somthing...
  # Testing to check for img tag. Make sure I am on the correct page
  # save_and_open_page
  # assert page.has_content?('<img>'), "Expected an img tag, but didn't one..."
  assert page.should have_xpath("//img[@alt='Label-200']")
end



Given(/^I choose "(.*?)" as my service type$/) do |service|
  select service
end

Then(/^I should not see a shipping label$/) do

end

Then(/^I should see an error telling me to select a mandatory add on$/) do
  assert page.has_content?("You must include one of the following add ons: Collect on Delivery, Registered Mail, Certified Mail, USPS Insurance")
end

Given(/^I request a label for something weighing "(.*?)" from "(.*?)" to "(.*?)"$/) do |weight, from_zip_code, to_zip_code|
  fill_in "shipping_label[from_address_attributes][zip_code]", :with => from_zip_code
  fill_in "shipping_label[to_address_attributes][zip_code]", :with => to_zip_code
  fill_in "shipping_label[weight]", :with => weight
end

Then(/^I should see only those addons relevant to this service type$/) do
  # save_and_open_page
  sleep 2
end

Given(/^I choose the "(.*?)" addon$/) do |add_on_codes|
  check "shipping_label_#{add_on_codes}"
end


Then(/^I enter (\d+) bucks for insurance$/) do |amount|
  fill_in "shipping_label[insurance_amount]", :with => amount
end
