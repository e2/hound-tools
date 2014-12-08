require "thor"
require "yaml"

require "hound/tools/hound_yml"
require "hound/tools/hound_defaults"
require "hound/tools/rubocop_yml"

require "hound/tools/runner"

module Hound
  module Tools
    class Cli < Thor
      INSTRUCTIONS = <<-EOS
         **** WARNING!!! ****

        1. All Rubocop offenses are initially ignored! (see .rubocop_todo.yml
        to uncomment them)

        2. Fixing all offenses at once is discouraged unless:
          - you are the only person actively working on the project (or starting out)
          - you have accepted ALL the pull requests FIRST
          - you have merged ALL the local and remote branches and you are NOT
          currently maintaining multiple branches

        Instructions:
        =============

        1. edit .rubocop_todo.yml to uncomment offenses you want to fix now

        2. edit .rubocop.yml to exclude project specific files (e.g. Rakefile,
        etc.) and add overrides (meaning - rules/cops you want different from
        Hound's defaults)

        3. Run `bundle exec hound-tool` to see what HoundCi would report on
        your files (which almost give you the same results as running `bundle
        exec rubocop` now - if not, file an issue).

        HINT: for quickly fixing most offenses, you can uncomment those in
        `.rubocop_todo.yml` which include 'auto-correct' and simply run `bundle exec rubocop -a`

        HINT: check the rubocop README for tips on setting up rubocop with
        Rake, Guard and other tools

        Contributing
        ============

        Feel free to file issues at: https://github.com/e2/hound-tools

      EOS

      desc :init, "Initializes a project to match default HoundCi config"
      def init
        HoundYml.new.generate
        HoundDefaults.new.generate
        RubocopYml.new.generate

        unless Kernel.system("bundle show hound-tools > #{IO::NULL}")
          $stderr.puts <<-EOS
          Add hound-tools to your Gemfile like so:

              gem 'hound-tools', require: false

          EOS
        end

        # TODO: help setup Rakefile?

        Kernel.system("bundle exec rubocop --auto-gen")
        $stdout.puts INSTRUCTIONS
      end

      default_task :check
      desc :check, "Simulates a HoundCi check locally"
      def check
        options = {
          hound_yml_file: ".hound.yml",
          hound_ci_style_file: ".rubocop.hound_defaults.yml",
          debug: false,
          glob_pattern: "**/*.rb"
        }

        Runner.new(options).run
      end
    end
  end
end
