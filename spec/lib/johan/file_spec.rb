module Johan
  describe File do
    it ".create_symlink" do
      Johan::File.create_symlink 'test/link', to:'test/test.txt'
      Johan::File.symlinks('test').should eq ["test/link"]
      Johan::File.remove_symlink 'test/link'
    end

    describe ".remove_file" do
      it 'on a non-existing file should raise error' do
        lambda{ Johan::File.remove_file 'test/link' }.should raise_error AssertionFailure, 'test/link does not exist'
      end
    end

    describe ".remove_symlink" do
      it 'on a non-existing link should raise an error' do
        lambda{ Johan::File.remove_symlink 'test/link' }.should raise_error AssertionFailure, 'test/link does not exist'
      end 

      it 'on a regular file should raise an error' do
        begin
          Johan::File.touch_file 'test/test.txt'
          lambda{ Johan::File.remove_symlink 'test/test.txt' }.should raise_error AssertionFailure, 'test/test.txt is not a symlink' 
        ensure
          ::File.delete 'test/test.txt'
        end
      end
    end

    describe ".symlinks" do
      it 'empty' do
        Johan::File.symlinks('test').should be_empty
      end
    end
  end
end
