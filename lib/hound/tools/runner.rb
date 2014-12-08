module Hound
  module Tools
    class HoundConfig
      attr_reader :yaml
      attr_reader :rubocop_file
      attr_reader :rubocop_data

      def enabled?
        @enabled
      end

      def initialize(filename)
        @yaml = YAML.load(IO.read(filename))
        @enabled = @yaml["ruby"].fetch("enabled", true)
        @rubocop_file = @yaml["ruby"].fetch("config_file", nil)
        @rubocop_data = @rubocop_file && YAML.load(IO.read(@rubocop_file))
      end
    end

    class Runner
      DEFAULTS = {
        hound_yml_file: ".hound.yml",
        hound_ci_style_file: ".rubocop.hound_defaults.yml",
        debug: false,
        glob_pattern: "**/*.rb" # TODO: should be all files?
      }

      def initialize(options)
        @options = DEFAULTS.merge(options)
      end

      def run
        # TODO: clean this up
        # TODO: not covered by specs

        hound_yml_file = @options[:hound_yml_file]
        hound_ci_style = @options[:hound_ci_style_file]
        debug = @options[:debug]
        glob_pattern = @options[:glob_pattern]

        # NOTE: the code below should be written to EXACTLY do what Hound does

        require "rubocop"
        hound = HoundConfig.new(hound_yml_file)

        return "RuboCop disabled in #{hound_yml_file}" unless hound.enabled?

        # NOTE: treating hound.yml as a rubocop.yml file is deprecated
        custom = RuboCop::Config.new(hound.rubocop_data || hound.yml)
        custom.add_missing_namespaces
        custom.make_excludes_absolute

        default = RuboCop::ConfigLoader.configuration_from_file(hound_ci_style)
        config = RuboCop::ConfigLoader.merge(default, custom)

        cfg = RuboCop::Config.new(config, "")
        team = RuboCop::Cop::Team.new(RuboCop::Cop::Cop.all, cfg, debug: debug)

        Dir[glob_pattern].each do |path|
          next if File.directory?(path)
          file = RuboCop::ProcessedSource.new(IO.read(path))
          team.inspect_file(file).each do |violation|
            $stderr.puts "#{path}:#{violation.line}:#{violation.message}"
          end
        end
      end
    end
  end
end
