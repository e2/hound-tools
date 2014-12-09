require "hound/tools/hound_yml"

require_relative "template_spec"

RSpec.describe Hound::Tools::HoundYml do
  filename = ".hound.yml"

  it_behaves_like "a template", filename

  describe "#rubocop_filename" do
    before do
      allow(IO).to receive(:read).with(filename).and_return("ruby:\n  config_file: foo.yml")
    end

    it "reads the name from the YAML" do
      expect(subject.rubocop_filename).to eq('foo.yml')
    end
  end

  describe "#generate" do
    before do
      allow(IO).to receive(:read).
        with(/lib\/hound\/tools\/templates\/_#{filename}$/).and_call_original
      allow($stderr).to receive(:puts)
      allow($stdout).to receive(:puts)
    end

    context "with no #{filename}" do
      before do
        allow(IO).to receive(:read).with(filename).and_raise(Errno::ENOENT)
        allow(IO).to receive(:write).with(filename, anything)
        allow(FileUtils).to receive(:mkpath).with('.')
      end

      it "creates a valid #{filename} file" do
        expect(IO).to receive(:write).with(filename, anything) do |_file, data|
          expect(data).to be
          config = YAML::load(data)["ruby"]
          expect(config).to include("enabled" => true)
          expect(config).to include("config_file" => ".rubocop_merged_for_hound.yml")
        end

        subject.generate
      end
    end

    context "with existing invalid #{filename}" do
      before do
        allow(IO).to receive(:read).with(filename).and_return(data)
      end

      context "with no 'ruby' section" do
        let(:data) { "foo: :bar" }

        it "says the file is invalid" do
          msg = "Error: #{filename} is invalid! (No 'ruby' section)"
          expect($stderr).to receive(:puts).with(msg)
          subject.generate
        end

        it "returns false" do
          expect(subject.generate).to be_falsey
        end
      end

      context "with no 'config_file' section" do
        let(:data) { "ruby:\n\  bar: baz" }

        it "says the file is invalid" do
          msg = "Error: #{filename} is invalid! (No 'config_file' section)"
          expect($stderr).to receive(:puts).with(msg)
          subject.generate
        end
      end
    end
  end
end
