require 'spec_helper'

describe 'comments/verify' do
  let(:comment){ mock_model(Comment, name:'Some name', content:'Some comment').as_new_record }
  let(:rendering){ Capybara.string rendered }
  before do
    assign :comment, comment
    render
  end
  subject{ rendering }

  context 'div.notice' do
    subject{ rendering.find 'div.title' }
    its(:text){ should eq "Please confirm the contents before sending." }
  end

  it{ should have_selector 'ul.info' }
  it{ should have_selector 'form#new_comment' }
end
