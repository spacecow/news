require 'spec_helper'

describe 'logs/index' do
  let(:month){ create :month }
  before do
    assign(:months, [month])
    render
  end

  subject{ Capybara.string rendered }
  it{ should have_selector 'div.months' }
end
