Then /^I should see the following (\w+):$/ do |mdl,tbl|
  tbl.diff! tableish("table##{mdl} tr", 'td')
end

def table_row(tbl=nil,order)
  if tbl.nil?
    "table tr:nth-child(#{digit order})"
  else
    "table##{tbl} tr:nth-child(#{digit order})"
  end
end
