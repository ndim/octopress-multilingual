begin
  require 'octopress'
  require 'digest/md5'
rescue LoadError
end

if defined? Octopress::Command
  module Octopress
    module Multilingual
      class Translate < Command
        def self.init_with_program(p)
          p.command(:id) do |c|
            c.syntax 'id <path> [path path...]>'
            c.description "Generate a uniqe id to link translated posts or pages."

            c.action do |args|
              generate_id(args)
            end
          end
        end

        def self.generate_id(paths)
          id = Digest::MD5.hexdigest(paths.join)
          translated = []
          paths.each do |path|
            if File.file? path
              contents = File.read(path)
              contents.sub!(/\A(---\s+.+?\s+)---/m) do
                fm = $1.sub(/translation_id:.+\n?/,'')
                fm << "translation_id: #{id}\n"
                fm << "---"
              end

              File.open(path, 'w+') {|f| f.write(contents) }

              translated << path
            end
          end

          puts "translation_id: #{id}"
          puts "Added to:"
          puts translated.map {|p| "  - #{p}" }.join("\n")
        end
      end
    end
  end
end
