Then /^I should see "([^"]*)" in the (.+) table row$/ do |txt,order|
  with_scope("#{table_row order}") do
    page.should have_content(txt)
  end
end

When /^I follow "([^"]*)" within the (.+) table row$/ do |lnk,order|
  When %(I follow "#{lnk}" within "#{table_row order}")
end

Then /^I should see "([^"]*)" within the (.+) table row$/ do |txt,order|
  Then %(I should see "#{txt}" within "#{table_row order}")
end
Then /^I should not see "([^"]*)" within the (.+) table row$/ do |txt,order|
  Then %(I should not see "#{txt}" within "#{table_row order}")
end

Then /^I should see links "([^"]*)" within the (.+) table row$/ do |lnks,order|
  all("#{table_row order} a").map(&:text).join(", ").should eq lnks
end



def table_row(order); "table tr:nth-child(#{digit order})" end
