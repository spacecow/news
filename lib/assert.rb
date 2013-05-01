class AssertionFailure < StandardError
end

class Object
  def assert_equal(s1, s2, message="#{s1} != #{s2}")
    if $AVLUSA
      raise AssertionFailure.new(message) if s1!=s2 
    end
  end

  def assert_file file, msg="#{file} does not exist"
    if $AVLUSA
      raise AssertionFailure.new(msg) unless File.exists?(file)
    end
  end

  def assert_hash hash, message="#{hash} is not a hash"
    if $AVLUSA
      raise AssertionFailure unless hash.instance_of? Hash
    end
  end

  def assert_match s1, match, msg="#{s1} does not match #{match}" 
    raise AssertionFailure.new(msg) unless s1 =~ match
  end

  def assert_symlink symlink, msg="#{symlink} is not a symlink"
    if $AVLUSA
      begin
        File.readlink symlink
      rescue Errno::ENOENT
        assert_file symlink
      rescue Errno::EINVAL
        raise AssertionFailure.new(msg)
      end
    end
  end

  def assert_true(b, message='assertion not true')
    if $AVLUSA
      raise AssertionFailure.new(message) unless b 
    end
  end

  def assert_not_equal(s1, s2, message="-#{s1} and #{s2} is equal-")
    raise AssertionFailure.new(message) if s1==s2 
  end

  def assert_not_nil(s, message="-#{s} is nil-")
    raise AssertionFailure.new(message) if s == nil 
  end
end
