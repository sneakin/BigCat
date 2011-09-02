describe BigCat::Formatter do
  describe '#write' do
    subject { described_class.new(mock('output stream', :flush => nil, :puts => nil)) }

    it "puts the argument to the output stream using the double size font" do
      subject.output.should_receive(:puts).with(BigCat::String.new("hello").big_top_half)
      subject.output.should_receive(:puts).with(BigCat::String.new("hello").big_bottom_half)

      subject.write("hello")
    end

    it "flushes the output" do
      subject.output.should_receive(:flush)
      subject.write("hello")
    end

    context 'argument is just a newline' do
      it "puts a new line on the output" do
        subject.output.should_receive(:puts).with("\n")
        subject.write("\n")
      end
    end
  end
end
