require 'spec_helper'

describe CommentPresenter do
  let(:captcha){ NegativeCaptcha.new(:fields => [:name, :email, :affiliation, :content])}
  let(:comment){ mock_model Comment }
  let(:presenter){ CommentPresenter.new(comment,view) }
  subject{ rendering }

  describe '.captcha_form' do
    before{ controller.stub(:current_user){ nil }}
    let(:rendering){ Capybara.string presenter.captcha_form captcha}
    it{ should have_selector 'form#new_comment' }
  end

  describe '.info' do
    let(:rendering){ Capybara.string presenter.info }
    it{ should have_selector 'li', count:4 }
    
    context 'name' do
      before{ comment.should_receive(:name).and_return 'Some name' }
      subject{ rendering.all('li')[0] }
      its(:text){ should match /Name:.*Some name/m }
    end

    context 'affiliation' do
      before{ comment.should_receive(:affiliation).and_return 'Some affiliation' }
      subject{ rendering.all('li')[1] }
      its(:text){ should match /Affiliation:.*Some affiliation/m }
    end

    context 'email' do
      before{ comment.should_receive(:email).and_return 'Some email' }
      subject{ rendering.all('li')[2] }
      its(:text){ should match /Email:.*Some email/m }
    end

    context 'comment' do
      before{ comment.should_receive(:content).and_return 'Some comment' }
      subject{ rendering.all('li')[3] }
      its(:text){ should match /Comment:.*Some comment/m }
    end
  end
end
