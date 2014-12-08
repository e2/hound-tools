RSpec.shared_examples "a template" do |filename|
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
    end

    it "displays the file was created" do
      expect($stdout).to receive(:puts).with("#{filename} created")
      subject.generate
    end

    context "with existing valid #{filename}" do
      let(:contents) { IO.read("lib/hound/tools/templates/_#{filename}") }

      before do
        allow(IO).to receive(:read).with(filename).and_return(contents)
      end

      it "displays the files was skipped" do
        expect($stdout).to receive(:puts).with("#{filename} (seems ok - skipped)")
        subject.generate
      end

      it "returns true" do
        expect(subject.generate).to be_truthy
      end
    end
  end
end
