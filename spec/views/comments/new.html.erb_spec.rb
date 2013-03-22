require 'spec_helper'

describe 'comments/new' do
  let(:captcha){ NegativeCaptcha.new(fields:[:name, :email, :affiliation, :content])}
  let(:comment){ mock_model Comment }
  before do
    controller.stub(:current_user){ nil }
    assign :comment, comment
    assign :captcha, captcha
    render
  end

  subject{ Capybara.string(rendered) }
  it{ should have_selector 'div.title' }
  it{ should have_selector 'div.form' }
  it{ should have_selector 'table' }
end
