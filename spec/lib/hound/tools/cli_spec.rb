require "hound/tools/cli"

module Hound
  RSpec.describe Tools::Cli do
    let(:hound_yml) { instance_double(Tools::HoundYml, generate: nil) }
    let(:default_yml) { instance_double(Tools::HoundDefaults, generate: nil) }
    let(:rubocop_yml) { instance_double(Tools::HoundDefaults, generate: nil) }
    let(:bundler_result) { true }

    before do
      allow(Tools::HoundYml).to receive(:new).and_return(hound_yml)
      allow(Tools::HoundDefaults).to receive(:new).and_return(default_yml)
      allow(Tools::RubocopYml).to receive(:new).and_return(rubocop_yml)

      allow(Kernel).to receive(:system).
        with("bundle show hound-tools > #{IO::NULL}").
        and_return(bundler_result)

      allow(Kernel).to receive(:system).with("bundle exec rubocop --auto-gen")

      allow($stderr).to receive(:puts)
      allow($stdout).to receive(:puts)
    end

    describe "#init" do
      before { subject.init }

      it "generates a .hound.yml" do
        expect(hound_yml).to have_received(:generate)
      end

      it "generates a default Hound yml" do
        expect(default_yml).to have_received(:generate)
      end

      it "generates a default .rubocop.yml" do
        expect(rubocop_yml).to have_received(:generate)
      end

      context "without hound-tools in the Gemfile" do
        let(:bundler_result) { false }
        it "shows message about adding hound-tools to Gemfile" do
          expect($stderr).to have_received(:puts).with(/Add hound-tools to your Gemfile/)
        end
      end

      context "with hound-tools in the Gemfile" do
        it "does not show message about adding hound-tools to Gemfile" do
          expect($stderr).to_not have_received(:puts)
        end
      end

      it "runs rubocop --auto-gen" do
        expect(Kernel).to have_received(:system).
          with('bundle exec rubocop --auto-gen')
      end
    end

    describe "#check" do
      pending
    end
  end
end
