require 'assert'
require 'json'

module Johan
  $AVLUSA = 1

  class File
    class << self
      # Shell commands ------------------------
      def touch_file file
        file = ::File.open(file, 'w')
        file.close
      end

      def create_symlink symlink, hash 
        assert_not_nil hash[:to]
        %x[ln -s #{hash[:to]} #{symlink}]
      end

      def copy_file file, hash
        assert_not_nil hash[:to]
        %x[cp #{file} #{hash[:to]}]
      end

      def remove_file file
        assert_file file
        ::File.delete file
      end

      def remove_symlink symlink
        assert_symlink symlink
        ::File.delete symlink
      end
      # ---------------------------------------
      # --- Save symlinks and their map
      def pre_deploy root=Rails.root
        hash = {}
        symlinks(root).each do |symlink|
          hash.merge! map_symlink(symlink)
          unlink symlink
        end
        save_map hash
      end

      def post_deploy
        load_map.each do |key,value|
          link key, to:value
        end
      end

      def link file, hash
        assert_true ::File.exists?(file)
        assert_not_nil hash[:to]
        remove_file file
        create_symlink file, to:hash[:to]
      end

      def unlink symlink
        origin = ::File.realpath symlink
        remove_symlink symlink
        copy_file origin, to:symlink
      end

      def map_symlink symlink
        assert_symlink symlink
        origin = Rails.root.join(::File.realpath(symlink)).to_s
        {symlink => origin}
      end

      def save_map hash
        assert_hash hash
        ::File.open(symlinksfile,'w') do |file|
          file.write hash.to_json 
        end 
      end

      def load_map
        ::File.open(symlinksfile) do |file|
          JSON.parse file.readline
        end
      end
      # ---------------------------------------
      # --- For rake --------------------------
      def replace_symlinks root=Rails.root
        symlinks(root).each do |symlink|
          unlink symlink
        end
      end

      def save_symlinks_map root=Rails.root
        hash = {}
        symlinks(root).each do |symlink|
          hash.merge! map_symlink(symlink)
        end
        save_map hash
      end
      # ---------------------------------------
      def files dir
        %x[find #{dir}].split
      end

      def symlinksfile; "data/symlinks.txt" end

      def symlinks dir 
        %x[find #{dir} -type l].split
      end

    end
  end
end
