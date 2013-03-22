require 'spec_helper'

describe CommentsController do
  let(:attributes){{ :name=>"Some name", :email=>"", :affiliation=>"", :content=>"Some comment" }}

  describe '#validate' do
    let(:captcha){ mock :captcha }
    before do
      NegativeCaptcha.should_receive(:new).and_return captcha
      captcha.should_receive(:values).twice.and_return attributes
      captcha.should_receive(:valid?).and_return true
      put :validate
    end

    describe Comment do
      subject{ Comment }
      its(:count){ should be 0 }
    end

    describe 'response' do
      subject{ response }
      it{ should redirect_to verify_comments_path(comment:attributes) }
    end
  end

  describe '#create' do
    before do
      put :create, comment:attributes
    end

    describe Comment do
      subject{ Comment }
      its(:count){ should be 1 }
    end
  end
end

