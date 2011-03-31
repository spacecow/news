Then /^I should see "([^"]*)" as (\w+) flash message$/ do |txt,cat|
  with_scope("div#flash_#{cat}"){ page.text.should eq txt }
end
