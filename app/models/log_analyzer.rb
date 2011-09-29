class LogAnalyzer
  class << self
    def load(s=nil); %x[cat "#{path}" | grep "#{s}"].split("\n") end
    def path; raise NotImplementedError end
    def save(s); File.open(path,"w"){|f| f.write(s)} end
  end
end
