class Category < ActiveRecord::Base
  belongs_to :month
  has_many :logs, dependent: :destroy, after_add: :inc_log_count

  attr_accessible :name

  validates :name, presence:true
  validates :month, presence:true

  private

    def inc_log_count(log)
      update_attribute(:unique_log_count, unique_log_count+1) if logs.where('id != ?',log.id).where(ip:log.ip).empty?
      update_attribute(:log_count, log_count+1)
    end
end
