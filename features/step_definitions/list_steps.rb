Then /^I should see "([^"]*)" listed (\w+)$/ do |txt,order|
  with_scope("li:nth-child(#{digit order})") do
    page.should have_content(txt)
  end
end
