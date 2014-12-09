require "yaml"

require "hound/tools/template"

module Hound
  module Tools
    class HoundOverrides
      include Template

      def initialize
        super(".hound/overrides.yml")
      end

      private

      def _validate(content)
        config = YAML.load(content)
        cops = config["AllCops"]
        fail InvalidTemplate, "No AllCops section" unless cops

        # TODO: not tested
        fail InvalidTemplate, "Detected 'inherited_from' section" if config.key?('inherited_from')
      end
    end
  end
end
