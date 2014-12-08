require 'yaml'

require "hound/tools/template"

module Hound
  module Tools
    class HoundYml
      include Template

      def initialize
        super('.hound.yml')
      end

      private

      def _validate(data)
        config = YAML.load(data)
        ruby = config['ruby']
        fail InvalidTemplate, "No 'ruby' section" unless ruby
        fail InvalidTemplate, "Expected 'ruby' section to be a hash, got #{ruby.inspect}" unless ruby.is_a?(Hash)
        fail InvalidTemplate, "No 'config_file' section" unless ruby.key?('config_file')
      end
    end
  end
end
