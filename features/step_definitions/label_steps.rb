Given /^I am on the shipping label printing page$/ do
  # Update the routes so that the homepage goes to the shipping label page for now
  visit('/')
end

Given /^I request a label for a "(.*?)" weighing "(.*?)" from "(.*?)" to "(.*?)"$/ do |product, weight, from, to|
  # Package info being entered
  select "Package"
  select 'USPS Parcel Post'
  fill_in "shipping_label[weight]", :with => weight

  # From address info being entered
  fill_in "shipping_label[from_address_attributes][full_name]", :with => 'Corey Trombley'
  fill_in "shipping_label[from_address_attributes][address1]", :with => '1234 ABD Drive'
  fill_in "shipping_label[from_address_attributes][city]", :with => 'Queens'
  fill_in "shipping_label[from_address_attributes][state]", :with => 'NY'
  fill_in "shipping_label[from_address_attributes][zip_code]", :with => '11370'

  # To address info being entered
  fill_in "shipping_label[to_address_attributes][full_name]", :with => 'Elaine Trombley'
  fill_in "shipping_label[to_address_attributes][address1]", :with => '4321 ZYX Place'
  fill_in "shipping_label[to_address_attributes][city]", :with => 'Wantagh'
  fill_in "shipping_label[to_address_attributes][state]", :with => 'NY'
  fill_in "shipping_label[to_address_attributes][zip_code]", :with => '11793'
end

When /^I press "(.*?)"$/ do |value|
  click_button value
end

Then /^I should see a shipping label$/ do
  # TODO - tricky one to test.... will have a URL in the page, perhaps output it
  # somewhere on the view for now, and have a regexp to see that there is an image
  # in a box or somthing...

  # Testing to check for img tag. Make sure I am on the correct page
  page.has_content?('img')

  # Checks that the a label is shown. The alt tag is added from the label being generated.
  page.has_content?('alt="Label-200"')
end



Given(/^I choose "(.*?)" as my service type$/) do |arg1|
  select 'USPS Parcel Post'
end

Then(/^I should not see a shipping label$/) do
  page.has_content?('Please Select a package type')
end

Then(/^I should see "(.*?)"$/) do |arg1|
  page.has_content?('Please Select a package type')
end

Given(/^I request a label for something weighing "(.*?)" from "(.*?)" to "(.*?)"$/) do |weight, from_zip_code, to_zip_code|
  fill_in "shipping_label[weight]", :with => weight
  fill_in "shipping_label[from_address_attributes][zip_code]", :with => from_zip_code
  fill_in "shipping_label[to_address_attributes][zip_code]", :with => to_zip_code
end

Then(/^I should see only those addons relevant to this service type$/) do
  page.has_content?('#add-ons')
end

Given(/^I choose the "(.*?)" addon$/) do |add_on_codes|
  check 'SC-A-HP'
  check 'US-A-RRM'
  check 'US-A-INS'
  check 'US-A-CM'
end
