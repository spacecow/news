require 'spec_helper'

module Johan
  describe Linker do
    default = ['test', 'test/test', 'test/test/test.txt'] 
    let(:filename){ 'data/test_symlinks.txt' }
    let(:data){ {Rails.root.join("test/link").to_s => Rails.root.join("test/test/test.txt").to_s} }

    # - REPLACE SYMLINKS AND SAVE SYMLINKS MAP -
    describe '.pre_deploy' do
      it 'existing links' do
        Johan::File.should_receive('symlinks').with('test').and_return ['test/link']
        Linker.should_receive('unlink').with('test/link')
        Linker.should_receive('map_symlink').with('test/link').and_return ({"test/test/test.txt" => "test/link"})
        Linker.should_receive('save_map').with({'test/test/test.txt' => 'test/link'})
        Linker.pre_deploy 'test'
      end
    end

    it '.post_deploy' do
      Linker.should_receive(:load_map).and_return data
      Linker.should_receive(:link).with(data.keys.first, to:data.values.first)
      Linker.post_deploy
    end

    describe ".unlink" do
      it 'existing link' do
        Johan::File.create_symlink 'test/link', to:'test/test.txt'
        Linker.unlink 'test/link'
        Linker.files('test').should include 'test/link' 
        Johan::File.symlinks('test').should be_empty
        Johan::File.remove_file 'test/link'
      end
    end

    describe ".link" do
      let(:dir){ 'test' }
      let(:file){ "#{dir}/link" }
      it 'link to an existing file' do
        Johan::File.touch_file file 
        Linker.link file, to:Rails.root.join("#{dir}/test/test.txt").to_s
        Linker.files(dir).should include file 
        Johan::File.symlinks(dir).should eq [file]
        Johan::File.remove_symlink file
      end
    end

    describe '.map_symlink' do
      it 'existing link' do
        begin
          Johan::File.create_symlink 'test/link', to:'test/test.txt'
          Linker.map_symlink('test/link').should eq ({"test/link" => "#{Rails.root}/test/test/test.txt"})
        ensure
          Johan::File.remove_symlink 'test/link'
        end
      end

      it 'non-existing link' do
        lambda{ Linker.map_symlink('test/link')}.should raise_error AssertionFailure, 'test/link does not exist'
      end
    end

    # -- SAVE AND LOAD MAP ---------------------
    describe '.save_map' do
      it 'must be a hash' do
        lambda{ Linker.save_map("test/test/test.txt")}.should raise_error AssertionFailure
      end

      it 'to file' do
        Linker.should_receive('symlinksfile').twice.and_return filename
        begin
          Linker.save_map data
          Linker.load_map.should eq data
        ensure
          Johan::File.remove_file filename
        end
      end
    end
    # ------------------------------------------
  end
end
