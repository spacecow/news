require 'spec_helper'

describe 'months/_months.html.erb' do
  let(:month){ create :month }
  before do
    render 'months/months', months:[month,month]
  end
  let(:rendering){ Capybara.string(rendered) }
  subject{ rendering }

  it{ should have_selector 'div.month', count:2 }
end
