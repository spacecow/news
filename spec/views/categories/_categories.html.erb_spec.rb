require 'spec_helper'

describe 'categories/_categories.html.erb' do
  let(:category){ create :category }
  before do
    render 'categories/categories', categories:[category]
  end
  subject{ Capybara.string(rendered) }

  it{ should have_selector 'li.category' }
end
