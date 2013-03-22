require 'spec_helper'

describe Comment do
  context "create" do
    context "validation error" do
      it "name is blank" do
        lambda{ create :comment, name:'' }.should raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Name Name can\'t be blank')
      end

      it "content is blank" do
        lambda{ create :comment, content:'' }.should raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Content Comment can\'t be blank')
      end

      it "email is invalid" do
        lambda{ create :comment, email:'email' }.should raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Email Email is invalid')
      end
    end # validation error 

    context "valid" do
      it "email is blank" do
        lambda{ create :comment, email:'' }.should_not raise_error
      end
    end
  end
end
