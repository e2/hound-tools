require 'hound/tools/hound_defaults'

require_relative 'template_spec'

RSpec.describe Hound::Tools::HoundDefaults do
  filename = '.hound/defaults.yml'

  it_behaves_like 'a template', filename

  describe '#generate' do
    before do
      allow(IO).to receive(:read).
        with(/lib\/hound\/tools\/templates\/_#{filename}$/).and_call_original
      allow($stderr).to receive(:puts)
      allow($stdout).to receive(:puts)
      allow(FileUtils).to receive(:mkpath).with('.hound')
    end

    context "with no #{filename}" do
      before do
        allow(IO).to receive(:read).with(filename).and_raise(Errno::ENOENT)
        allow(IO).to receive(:write).with(filename, anything)
      end

      it "creates a valid #{filename} file" do
        expect(IO).to receive(:write).with(filename, anything) do |_file, data|
          expect(data).to be
          config = YAML::load(data)
          expect(config).to be
          expect(config).to include('StringLiterals' => { 'EnforcedStyle' => 'double_quotes' })
        end

        subject.generate
      end
    end

    context "with existing invalid #{filename}" do
      let(:contents) { 'foo: :bar' }
      before { allow(IO).to receive(:read).with(filename).and_return(contents) }

      it 'returns false' do
        expect(subject.generate).to be_falsey
      end

      it 'displays the file already exists' do
        msg = "Error: #{filename} is invalid! (No StringLiterals section)"
        expect($stderr).to receive(:puts).with(msg)
        subject.generate
      end
    end
  end
end
