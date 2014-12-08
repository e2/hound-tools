module Hound
  module Tools
    module Template
      class InvalidTemplate < RuntimeError
      end

      def initialize(filename)
        @filename = filename
      end

      def generate
        _validate(IO.read(@filename))
        $stdout.puts "#{@filename} (seems ok - skipped)"
        true
      rescue Errno::ENOENT
        IO.write(@filename, _template_for(@filename))
        $stdout.puts "#{@filename} created"
      rescue InvalidTemplate => e
        $stderr.puts "Error: #{@filename} is invalid! (#{e.message})"
      end

      private

      def _template_for(file)
        template_dir = Pathname.new(__FILE__).expand_path.dirname + "templates"
        path = template_dir + file.sub(/^\./, "_.")
        path.read
      end

      def _validate(_data)
        fail NotImplementedError
      end
    end
  end
end
