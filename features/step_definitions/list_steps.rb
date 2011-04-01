Then /^I should see "([^"]*)" within the (\w+) listing$/ do |txt,order|
  with_scope(list_no order) do
    page.should have_content(txt)
  end
end
Then /^I should see "([^"]*)" within the (\w+) "([^"]*)" listing$/ do |txt,order,lst|
  with_scope(list_no(lst,order)) do
    page.should have_content(txt)
  end
end

Then /^I should see no (\w+) "([^"]*)" listing$/ do |order,lst|
  page.should have_no_css(list_no(lst,order))
end


def list_no(order); "ul li:nth-child(#{digit order})" end
def list_no(lst,order); "ul##{lst} li:nth-child(#{digit order})" end
