class Month < ActiveRecord::Base
  has_many :categories

  attr_accessible :name

  validates :name, presence:true, uniqueness:true

  def category_log_count s
    return 0 if categories.empty?
    categories.where(name:s).first.try(:log_count) || 0
  end

  def date
    Date.parse("#{name}01")
  end

  def title
    date.strftime("%B %Y")
  end
end
