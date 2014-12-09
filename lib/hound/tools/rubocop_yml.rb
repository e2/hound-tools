require 'yaml'
require 'hound/tools/template'

module Hound
  module Tools
    class RubocopYml
      include Template

      def initialize
        super '.rubocop.yml'
      end

      private

      def _validate(data)
        config = YAML.load(data)
        inherited = config['inherit_from']
        fail InvalidTemplate, "No 'inherit_from' section" unless inherited
        file = '.hound/defaults.yml'
        fail InvalidTemplate, "'#{file}' not inherited" unless inherited.include?(file)
      end
    end
  end
end
