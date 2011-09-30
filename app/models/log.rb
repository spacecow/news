class Log < ActiveRecord::Base
  def month_abbr; date.strftime("%b") end
  def month_no;   date.strftime("%m") end
  def month_to_s; date.strftime("%B") end
  
  class << self
    def load_date(s)
      Date.parse(s)
    end
  end
end

# == Schema Information
#
# Table name: logs
#
#  id   :integer(4)      not null, primary key
#  ip   :string(255)
#  date :datetime
#

