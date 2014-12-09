require "thor"
require "yaml"

require "hound/tools/hound_yml"
require "hound/tools/hound_defaults"
require "hound/tools/hound_overrides"
require "hound/tools/rubocop_yml"
require "hound/tools/merged_yml"

require "hound/tools/runner"

module Hound
  module Tools
    class Cli < Thor
      INSTRUCTIONS = <<-EOS

         **** WARNING!!! ****

        1. All Rubocop offenses are initially ignored! (see .rubocop_todo.yml and/or README)
          - tweak .rubocop_todo.yml and regenerate with `bundle exec hound-tools`

        2. Fixing all offenses at once is discouraged unless:
          - you are the only person actively working on the project (or starting out)
          - you have accepted ALL the pull requests FIRST
          - you have merged ALL the local and remote branches and you are NOT
          currently maintaining multiple branches

        Issues? Go here: https://github.com/e2/hound-tools/issues
      EOS

      desc :init, "Initializes a project to match default HoundCi config"
      def init
        HoundYml.new.generate
        HoundDefaults.new.generate
        HoundOverrides.new.generate
        RubocopYml.new.generate

        # TODO: help setup Rakefile?

        Kernel.system("bundle exec rubocop --auto-gen")

        MergedYml.new.generate

        $stdout.puts INSTRUCTIONS

        unless Kernel.system("bundle show hound-tools > #{IO::NULL}")
          $stderr.puts <<-EOS
          Add hound-tools to your Gemfile like so:

              gem 'hound-tools', require: false

          EOS
        end
      end

      default_task :check
      desc :check, "Simulates a HoundCi check locally"
      def check
        # TODO: add an "update" action?
        # TODO: only merge if necessary (files outdated)
        MergedYml.new.generate

        options = {
          hound_yml_file: ".hound.yml",
          hound_ci_style_file: ".hound/defaults.yml",
          debug: false,
          glob_pattern: "**/*.rb"
        }

        Runner.new(options).run
      end
    end
  end
end
