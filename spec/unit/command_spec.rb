require 'bigcat'
require 'stringio'

describe BigCat::Command do
  describe '.run!' do
    let(:instance) { mock('command').as_null_object }
    let(:input) { mock('input stream') }
    let(:output) { mock('output stream') }

    def run(arguments = [])
      described_class.run!(arguments, input, output)
    end

    before do
      described_class.should_receive(:new).and_return(instance)
    end

    it "creates an instance" do
      run
    end

    context 'with empty arguments' do
      it "adds the input stream to the instance's list of streams" do
        instance.should_receive(:add_stream).with(input)
        run
      end
    end

    context 'with arguments' do
      it "adds the arguments to the instance's list of streams as files" do
        instance.should_receive(:add_file).with('alpha')
        instance.should_receive(:add_file).with('beta')
        run(['alpha', 'beta'])
      end
    end

    it "creates a Formatter that uses the output stream" do
      BigCat::Formatter.should_receive(:new).with(output)
      run
    end

    it "runs the instance" do
      instance.should_receive(:run!)
      run
    end
  end

  describe 'initialization' do
    it "sets streams to an empty array" do
      subject.streams.should be_empty
    end
  end

  describe '#add_stream' do
    it "appends the argument to the streams array" do
      stream = mock('stream')
      lambda { subject.add_stream(stream) }.should change(subject.streams, :length).by(1)
      subject.streams.should include(stream)
    end
  end

  describe '#add_file' do
    context 'actual file' do
      it "opens the file for reading" do
        File.should_receive(:open).with(__FILE__, 'r')
        subject.add_file(__FILE__)
      end

      it "adds the file to the stream" do
        lambda { subject.add_file(__FILE__) }.should change(subject, :streams)
      end

      it "returns true" do
        subject.add_file(__FILE__).should be_true
      end
    end

    context 'directory' do
      it "writes no such file to stderr" do
        $stderr.should_receive(:puts).with("No such file: .")
        subject.add_file(".")
      end

      it "returns false" do
        subject.add_file(".").should be_false
      end
    end

    context 'no file' do
      it "writes no such file to stderr" do
        $stderr.should_receive(:puts).with("No such file: bah.txt")
        subject.add_file("bah.txt")
      end

      it "returns false" do
        subject.add_file("bah.txt").should be_false
      end
    end
  end

  describe '#run!' do
    subject { described_class.new }

    context 'without a formatter' do
      before do
        subject.add_stream(StringIO.new('alpha\n'))
      end

      it "raises an error" do
        lambda { subject.run! }.should raise_error
      end
    end

    context 'with a formatter' do
      let(:formatter) { mock('formatter') }

      before do
        subject.formatter = formatter
      end

      context 'with zero streams' do
        it "writes nothing" do
          formatter.should_not_receive(:write)
          subject.run!
        end
      end

      context 'with a stream' do
        let(:input) { StringIO.new("alpha\nbeta\n") }

        before do
          subject.add_stream(input)
        end

        it "writes each line of the stream to the formatter" do
          formatter.should_receive(:write).with("alpha\n")
          formatter.should_receive(:write).with("beta\n")

          subject.run!
        end

        it "closes the stream" do
          input.should_receive(:close)
          formatter.as_null_object

          subject.run!
        end
      end

      context 'with multiple streams' do
        let(:streams) do
          [ StringIO.new("alpha\n"),
            StringIO.new("beta\n")
          ]
        end

        before do
          streams.each { |s| subject.add_stream(s) }
        end

        it "writes each line of each stream to the formatter in the order of the streams" do
          formatter.should_receive(:write).with("alpha\n")
          formatter.should_receive(:write).with("beta\n")

          subject.run!
        end

        it "closes each stream" do
          streams.each { |s| s.should_receive(:close) }
          formatter.as_null_object

          subject.run!
        end
      end
    end
  end
end
