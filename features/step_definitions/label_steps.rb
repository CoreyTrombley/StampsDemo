Given /^I am on the shipping label printing page$/ do
  # Update the routes so that the homepage goes to the shipping label page for now
  visit('/')
end

Given /^I request a label for a "(.*?)" weighing "(.*?)" from "(.*?)" to "(.*?)"$/ do |product, weight, from, to|
  select "Package"
  select 'USPS Parcel Post'
  fill_in "shipping_label[weight]", :with => weight
  fill_in "shipping_label[from_address_attributes][full_name]", :with => 'Corey Trombley'
  fill_in "shipping_label[from_address_attributes][address1]", :with => '1234 ABD Drive'
  fill_in "shipping_label[from_address_attributes][city]", :with => 'Queens'
  fill_in "shipping_label[from_address_attributes][state]", :with => 'NY'
  fill_in "shipping_label[from_address_attributes][zip_code]", :with => '11370'

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
  save_and_open_page
  assert page.has_content?('img')
  # assert page.has_content?('alt="Label-200"')
end
