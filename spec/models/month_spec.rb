require 'spec_helper'

describe Month do
  describe ".title" do
    subject{ create :month, name:'1110' }
    its(:title){ should eq 'October 2011' }
  end
end
