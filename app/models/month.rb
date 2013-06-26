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

  def unique_category_log_count s
    return 0 if categories.empty?
    if s != 'pdf'
      categories.where(name:s).first.try(:unique_log_count) || 0
    else
      categories.where('name != ?','page_top').map{|e| e.try(:unique_log_count) || 0}.sum
    end
  end

  class << self
    def to_csv
      CSV.generate do |csv|
        csv << ["Month", "Unique top page hits", "Unique total pdf download"]
        order(:name).each do |month|
          csv <<  [month.date, month.unique_category_log_count('page_top'), month.unique_category_log_count('pdf')]
        end

        csv << []
        heads = ["Month"]
        heads << Category.all.map(&:name).uniq.sort.select{|e| e =~ /pdf/}
        csv << heads.flatten 
        order(:name).each do |month|
          elems = [month.date]
          Category.all.map(&:name).uniq.sort.select{|e| e =~ /pdf/}.each do |s| 
            elems << [month.unique_category_log_count(s)]
          end
          csv << elems.flatten
        end
      end
    end
  end
end
