require 'assert'
require 'json'

module Johan
  $AVLUSA = 1

  class Linker
    class << self
      # --- Save symlinks and their map
      def pre_deploy root=Rails.root
        hash = {}
        Johan::File.symlinks(root).each do |symlink|
          hash.merge! map_symlink(symlink)
          unlink symlink
          p "#{symlink} saved"
        end
        save_map hash
      end

      def post_deploy
        load_map.each do |key,value|
          link key, to:value
          p "#{key} linked"
        end
      end

      def link file, hash
        assert_true ::File.exists?(file)
        assert_not_nil hash[:to]
        Johan::File.remove_file file
        Johan::File.create_symlink file, to:hash[:to]
      end

      def unlink symlink
        origin = ::File.realpath symlink
        Johan::File.remove_symlink symlink
        Johan::File.copy_file origin, to:symlink
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
        Johan::File.symlinks(root).each do |symlink|
          unlink symlink
        end
      end

      def save_symlinks_map root=Rails.root
        hash = {}
        Johan::File.symlinks(root).each do |symlink|
          hash.merge! map_symlink(symlink)
        end
        save_map hash
      end
      # ---------------------------------------
      def files dir
        %x[find #{dir}].split
      end

      def symlinksfile; "data/symlinks.txt" end
    end
  end
end
