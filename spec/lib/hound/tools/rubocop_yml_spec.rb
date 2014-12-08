require "hound/tools/rubocop_yml"

require_relative "template_spec"

RSpec.describe Hound::Tools::RubocopYml do
  filename = ".rubocop.yml"
  it_behaves_like "a template", filename

  describe "#generate" do
    before do
      allow(IO).to receive(:read).
        with(/lib\/hound\/tools\/templates\/_#{filename}$/).and_call_original
      allow($stderr).to receive(:puts)
      allow($stdout).to receive(:puts)
    end

    context "with no #{filename}" do
      before do
        allow(IO).to receive(:read).with("#{filename}").and_raise(Errno::ENOENT)
        allow(IO).to receive(:write).with("#{filename}", anything)
      end

      it "creates a valid #{filename} file" do
        expect(IO).to receive(:write).with("#{filename}", anything) do |_file, data|
          expect(data).to be
          config = YAML::load(data)["inherit_from"]
          expect(config).to match_array(%w(.rubocop.hound_defaults.yml .rubocop_todo.yml))
        end

        subject.generate
      end
    end

    context "with existing invalid #{filename}" do
      before do
        allow(IO).to receive(:read).with("#{filename}").and_return(data)
      end

      context "with no 'inherit_from' section" do
        let(:data) { "foo: :bar" }

        it "says the file is invalid" do
          msg = "Error: #{filename} is invalid! (No 'inherit_from' section)"
          expect($stderr).to receive(:puts).with(msg)
          subject.generate
        end

        it "returns false" do
          expect(subject.generate).to be_falsey
        end
      end

      context "when inherit_from lacks '.rubocop.hound_defaults.yml'" do
        let(:data) { "inherit_from:\n\  bar: baz" }

        it "says the file is invalid" do
          msg = "Error: #{filename} is invalid! ('.rubocop.hound_defaults.yml' not inherited)"
          expect($stderr).to receive(:puts).with(msg)
          subject.generate
        end
      end
    end
  end
end
