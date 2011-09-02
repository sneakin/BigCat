require 'bigcat'

describe BigCat::Command do
  describe '#run!' do
    subject { described_class.new(mock('input stream'), mock('formatter', :write => nil)) }

    it "reads from the input until it raises an EOFError" do
      subject.input.should_receive(:readline).and_raise(EOFError)
      subject.formatter.should_not_receive(:write)

      subject.run!
    end

    it "writes each read line using the double size font" do
      subject.input.should_receive(:readline).and_return("hello\n", "world\n")
      subject.input.should_receive(:readline).and_raise(EOFError)
      subject.formatter.should_receive(:write).with("hello\n")
      subject.formatter.should_receive(:write).with("world\n")

      subject.run!
    end

    it "catches the EOFError" do
      subject.input.should_receive(:readline).and_raise(EOFError)
      lambda { subject.run! }.should_not raise_error(EOFError)
    end
  end
end
