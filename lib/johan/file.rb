module Johan
  class File
    class << self
      def copy_file file, hash
        assert_not_nil hash[:to]
        %x[cp #{file} #{hash[:to]}]
      end

      def create_symlink symlink, hash 
        assert_not_nil hash[:to]
        %x[ln -s #{hash[:to]} #{symlink}]
      end

      def symlinks dir 
        %x[find #{dir} -type l].split
      end

      def remove_file file
        assert_file file
        ::File.delete file
      end

      def remove_symlink symlink
        assert_symlink symlink
        ::File.delete symlink
      end

      def touch_file file
        file = ::File.open(file, 'w')
        file.close
      end
    end
  end
end
