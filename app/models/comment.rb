class Comment < ActiveRecord::Base
  attr_accessible :content, :name, :email, :affiliation
  belongs_to :user
  validates_presence_of :name, :email, :affiliation, :content
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
end
