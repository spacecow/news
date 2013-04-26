require 'spec_helper'

describe 'categories/_category.html.erb' do
  let(:category){ create :category }
  before do
    render category
  end
  let(:rendering){ Capybara.string(rendered) }
  subject{ rendering }

  it{ should have_selector 'span.counts' }
end
