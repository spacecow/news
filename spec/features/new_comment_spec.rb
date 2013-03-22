require 'spec_helper'

describe 'Comments' do
  describe '#new' do
    before do
      visit new_comment_path
      fill_in 'Name', with:'Some name'
      fill_in 'Comment', with:'Some comment'
    end

    context 'new comment' do
      before{ click_button 'Send Comment' }
      it{ page.should_not have_content 'Name can\'t be blank' }
    end

    context 'name validation error' do
      before do
        fill_in 'Name', with:''
        click_button 'Send Comment'
      end

      it{ page.should have_content 'Name can\'t be blank' }
    end

    context 'email validation error' do
      before do
        fill_in 'Email', with:'email'
        click_button 'Send Comment'
      end

      it{ page.should have_content 'Email is invalid' }
    end
  end
end 
