RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.disable_monkey_patching!

  # config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  # config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed

  config.before do
    %w(write read).each do |meth|
      allow(IO).to receive(meth) do |*args|
        fail "stub me: IO.#{meth}(#{args.map(&:inspect) * ", "})"
      end
    end

    %w(mkdir mkpath).each do |meth|
      allow(FileUtils).to receive(meth) do |*args|
        fail "stub me: FileUtils.#{meth}(#{args.map(&:inspect) * ", "})"
      end
    end

    %w(` system).each do |meth|
      allow(Kernel).to receive(meth) do |*args|
        fail "stub me: Kernel.#{meth}(#{args.map(&:inspect) * ", "})"
      end
    end

  end
end
