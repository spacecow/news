Then /^I should see "([^"]*)" as (\w+) flash message$/ do |txt,cat|
  with_scope("div#flash_#{cat}"){ page.text.should eq txt }
end

Then /^I should see "([^"]*)" within the (.+) section$/ do |txt,div|
  with_scope("div##{underscore div}") do
    page.should have_content(txt)
  end
end

When /^I follow "([^"]*)" within the (.+) section$/ do |lnk,div|
  When %(I follow "#{lnk}" within "div##{underscore div}")
end
