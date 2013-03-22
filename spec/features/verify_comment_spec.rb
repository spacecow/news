require 'spec_helper'

describe 'Comments' do
  describe '#verify' do
    let(:attributes){{ :name=>"Some name", :email=>"", :affiliation=>"", :content=>"Some comment" }}
    before{ visit verify_comments_path(comment:attributes) }

    describe 'layout' do
      it{ page.should have_content 'Some name' }
      it{ page.should have_content 'Some comment' }
    end
  end
end
