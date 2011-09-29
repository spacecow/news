class Log
  def initialize(a)
    @ip = a[0]
    @date = Log.load_date(a[1]) 
  end

  def date; @date end
  def month_abbr; @date.strftime("%b") end
  def month_no; @date.strftime("%m") end
  def month_to_s; @date.strftime("%B") end
  def ip; @ip end
  
  class << self
    def load_date(s)
      Date.parse(s)
    end
  end
end
