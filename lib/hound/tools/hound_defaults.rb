require 'yaml'

require 'hound/tools/template'

module Hound
  module Tools
    class HoundDefaults
      include Template

      def initialize
        super('.hound/defaults.yml')
      end

      private

      def _validate(content)
        config = YAML.load(content)
        literals = config['StringLiterals']
        fail InvalidTemplate, 'No StringLiterals section' unless literals

        quote_style = literals['EnforcedStyle']
        fail InvalidTemplate, 'No EnforcedStyle section' unless quote_style
        fail InvalidTemplate, 'No double_quotes value'  unless quote_style == 'double_quotes'

        # TODO: not tested
        fail InvalidTemplate, "Detected 'inherited_from' section" if config.key?('inherited_from')
      end
    end
  end
end
