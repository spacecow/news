require 'spec_helper'

describe 'comments/_captcha_form.html.erb' do
  let(:captcha){ NegativeCaptcha.new(
    :fields => [:name, :email, :affiliation, :content]
  )}
  let(:comment){ mock_model Comment }
  before do
    controller.stub(:current_user){ nil }
    render 'comments/captcha_form', comment:comment, captcha:captcha
  end
  let(:rendering){ Capybara.string(rendered) }

  %w(Name Affiliation Email Comment).each do |attr|
    describe attr do
      subject{ rendering.find_field attr }
      its(:value){ should be_blank }
    end
  end
end
