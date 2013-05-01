require 'assert'
require 'spec_helper'

module Johan
  describe File do
    default = ['test', 'test/test', 'test/test/test.txt'] 
    let(:filename){ 'data/test_symlinks.txt' }
    let(:data){ {Rails.root.join("test/link").to_s => Rails.root.join("test/test/test.txt").to_s} }

    # ---- CREATE AND REMOVE SYMLINKS ----------
    it ".create_symlink" do
      begin
        Johan::File.create_symlink 'test/link', to:'test/test.txt'
        Johan::File.symlinks('test').should eq ["test/link"]
      ensure
        Johan::File.remove_symlink 'test/link'
      end
    end

    describe ".remove_symlink" do
      it 'on a non-existing link should raise an error' do
        lambda{ Johan::File.remove_symlink 'test/link' }.should raise_error AssertionFailure, 'test/link does not exist'
      end 

      it 'on a regular file should raise an error' do
        begin
          ::File.new('test/test.txt', 'w')
          lambda{ Johan::File.remove_symlink 'test/test.txt' }.should raise_error AssertionFailure, 'test/test.txt is not a symlink' 
        ensure
          ::File.delete 'test/test.txt'
        end
      end
    end

    describe ".remove_file" do
      it 'on a non-existing file should raise error' do
        lambda{ Johan::File.remove_file 'test/link' }.should raise_error AssertionFailure, 'test/link does not exist'
      end
    end
    # ------------------------------------------
    # - REPLACE SYMLINKS AND SAVE SYMLINKS MAP -
    describe '.pre_deploy' do
      it 'existing links' do
        Johan::File.should_receive('symlinks').with('test').and_return ['test/link']
        Johan::File.should_receive('unlink').with('test/link')
        Johan::File.should_receive('map_symlink').with('test/link').and_return ({"test/test/test.txt" => "test/link"})
        Johan::File.should_receive('save_map').with({'test/test/test.txt' => 'test/link'})
        Johan::File.pre_deploy 'test'
      end
    end

    it '.post_deploy' do
      Johan::File.should_receive(:load_map).and_return data
      Johan::File.should_receive(:link).with(data.keys.first, to:data.values.first)
      Johan::File.post_deploy
    end

    describe ".unlink" do
      it 'existing link' do
        begin
          Johan::File.create_symlink 'test/link', to:'test/test.txt'
          Johan::File.unlink 'test/link'
          Johan::File.files('test').should include 'test/link' 
          Johan::File.symlinks('test').should be_empty
        ensure
          Johan::File.remove_file 'test/link'
        end 
      end
    end

    describe ".link" do
      let(:dir){ 'test' }
      let(:file){ "#{dir}/link" }
      it 'link to an existing file' do
        begin
          Johan::File.touch_file file 
          Johan::File.link file, to:Rails.root.join("#{dir}/test/test.txt").to_s
          Johan::File.files(dir).should include file 
          Johan::File.symlinks(dir).should eq [file]
        ensure
          Johan::File.remove_symlink file
        end
      end
    end

    describe '.map_symlink' do
      it 'existing link' do
        begin
          Johan::File.create_symlink 'test/link', to:'test/test.txt'
          Johan::File.map_symlink('test/link').should eq ({"test/link" => "#{Rails.root}/test/test/test.txt"})
        ensure
          Johan::File.remove_symlink 'test/link'
        end
      end

      it 'non-existing link' do
        lambda{ Johan::File.map_symlink('test/link')}.should raise_error AssertionFailure, 'test/link does not exist'
      end
    end

    # -- SAVE AND LOAD MAP ---------------------
    describe '.save_map' do
      it 'must be a hash' do
        lambda{ Johan::File.save_map("test/test/test.txt")}.should raise_error AssertionFailure
      end

      it 'to file' do
        Johan::File.should_receive('symlinksfile').twice.and_return filename
        begin
          Johan::File.save_map data
          Johan::File.load_map.should eq data
        ensure
          Johan::File.remove_file filename
        end
      end
    end
    # ------------------------------------------
    describe ".symlinks" do
      it 'empty' do
        Johan::File.symlinks('test').should be_empty
      end
    end
  end
end
