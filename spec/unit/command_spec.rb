require 'bigcat'

describe BigCat::Command do
  context 'initialized witohut arguments' do
    it "reads from STDIN" do
      subject.input.should == $stdin
    end

    it "writes to STDOUT" do
      subject.output.should == $stdout
    end
  end

  describe '#run!' do
    subject { described_class.new(mock('input stream'), mock('output stream')) }

    it "reads from the input until it raises an EOFError" do
      subject.input.should_receive(:readline).and_raise(EOFError)
      subject.output.should_not_receive(:puts)

      subject.run!
    end

    it "writes each read line using the double size font" do
      subject.input.should_receive(:readline).and_return("hello\n", "world\n")
      subject.input.should_receive(:readline).and_raise(EOFError)
      subject.should_receive(:write).with("hello\n")
      subject.should_receive(:write).with("world\n")

      subject.run!
    end

    it "catches the EOFError" do
      subject.input.should_receive(:readline).and_raise(EOFError)
      lambda { subject.run! }.should_not raise_error(EOFError)
    end
  end

  describe '#write' do
    subject { described_class.new(mock('input stream'), mock('output stream', :flush => nil, :puts => nil)) }

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
