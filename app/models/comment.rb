# -*- coding: utf-8 -*-
class Comment < ActiveRecord::Base
  attr_accessible :content, :name, :email, :affiliation
  belongs_to :user
  validates_presence_of :name, :message => "#{I18n.t('errors.blank', :obj=>I18n.t('formtastic.labels.name'))}"
  validates_presence_of :content, :message => "#{I18n.t('errors.blank', :obj=>I18n.t('formtastic.labels.content'))}"
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i, :allow_blank => true, :message => "#{I18n.t('errors.invalid', :obj=>I18n.t('formtastic.labels.email'))}"

  def username
    return user.username if user
    I18n.t(:anonymous)
  end
end

# == Schema Information
#
# Table name: comments
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  email       :string(255)
#  affiliation :string(255)
#  content     :text
#  user_id     :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

