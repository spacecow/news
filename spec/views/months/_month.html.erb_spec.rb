require 'spec_helper'

describe 'months/_month.html.erb' do
  let(:month){ create :month }
  before{ render month }
  let(:rendering){ Capybara.string(rendered) }
  subject{ rendering }

  it{ should have_selector 'h3.subtitle' }
  it{ should have_selector 'ul.categories' }
end
