require 'timeout'
require 'open3'

describe 'bigcat' do
  let!(:bigcat) { Pathname.new(__FILE__).parent.parent.parent.join('bin', 'bigcat') }

  def run(*arguments, &block)
    Open3.popen3("#{bigcat} #{arguments.join(' ')}") do |i, o, e, wait|
      if block
        Timeout::timeout(20) do
          block.call(i, o, e)
        end
      end

      i.close

      # for ruby 1.9
      return wait.value.exitstatus if wait
    end

    # for ruby 1.8
    $?.exitstatus
  end

  context 'without any arguments' do
    context 'immediate EOF' do
      it "exits with retval of 0" do
        run.should == 0
      end
    end

    context 'immediate newline' do
      it "writes two empty lines" do
        run do |i, o, e|
          i.puts("")
          o.read(2).should == "\n\n"
        end
      end

      it "exits on EOF" do
        ret = run do |i, o, e|
          i.puts
          o.read(2)
          o.close
        end
        ret.should == 0
      end
    end

    context 'multiple newlines' do
      it "writes two empty lines for each line" do
        run do |i, o, e|
          i.write("\n\n\n")
          o.read(6).should == "\n\n\n\n\n\n"
        end
      end
    end

    context 'line with characters' do
      let!(:string) { "Hello" }

      it "writes the line as two lines wrapped with VT100's top half double sized escape" do
        run do |i, o, e|
          i.puts(string)
          o.readline.should == "\e#3#{string}\n"
          o.readline.should == "\e#4#{string}\n"
        end
      end

      it "is waiting for more input" do
        run do |i, o, e|
          i.puts(string)
          o.readline
          o.readline

          i.puts(string)
          o.readline.should_not be_empty
        end
      end
    end

    context 'multiple lines before EOF' do
      it "writes each line wrapped as line pairs with VT100's double size escape sequences" do
        run do |i, o, e|
          i.puts("hello")
          i.puts("world")

          o.readline.should == "\e#3hello\n"
          o.readline.should == "\e#4hello\n"
          o.readline.should == "\e#3world\n"
          o.readline.should == "\e#4world\n"
        end
      end
    end
  end

  context 'with a filename as an argument' do
    let!(:path) { Pathname.new(__FILE__).parent.parent.parent.join('README.md') }
    let(:contents) { File.readlines(path) }

    it "embiggens each line of the file" do
      run(path) do |i, o, e|
        contents[-1] << "\n" unless contents[-1][-1].chr == "\n"

        contents.each do |line|
          if line == "\n"
            o.readline.should == "\n"
            o.readline.should == "\n"
          else
            o.readline.should == "\e#3#{line}"
            o.readline.should == "\e#4#{line}"
          end
        end
      end
    end

    context 'that does not exist' do
      let!(:path) { "bah.txt" }

      it "exits with a return value of 1" do
        run(path).should == 1
      end

      it "writes 'No such file: bah.txt' to stderr" do
        run(path) do |i, o, e|
          e.readline.should == "No such file: bah.txt\n"
        end
      end
    end

    context 'that is a directory' do
      let!(:path) { Pathname.new(__FILE__).parent }

      it "exits with a return value of 1" do
        run(path).should == 1
      end

      it "writes 'No such file: {dir}' to stderr" do
        run(path) do |i, o, e|
          e.readline.should == "No such file: #{path}\n"
        end
      end
    end
  end

  context 'with multiple filenames as arguments' do
    let(:paths) {
      [ Pathname.new(__FILE__).parent.parent.parent.join('README.md'),
        Pathname.new('foo.txt'),
        Pathname.new('bar.txt'),
        Pathname.new(__FILE__).parent,
        Pathname.new(__FILE__)
      ]
    }

    let(:contents) {
      paths.collect { |p| File.readlines(p) rescue nil }.reject { |p| p.nil? }
    }

    it "embiggens each line of each file in the order they're listed" do
      run(*paths) do |i, o, e|
        contents.each { |lines|
          lines[-1] << "\n" unless lines[-1][-1].chr == "\n"
        }

        contents.flatten.each do |line|
          if line == "\n"
            o.readline.should == "\n"
            o.readline.should == "\n"
          else
            o.readline.should == "\e#3#{line}"
            o.readline.should == "\e#4#{line}"
          end
        end
      end
    end

    it "writes 'No such file' messages for each not found file or directory" do
      rejects = paths.reject { |p| p.file? }.collect { |p|
        "No such file: #{p}\n"
      }

      run(*paths) do |i, o, e|
        rejects.length.times do |i|
          rejects.should include(e.readline)
        end
      end
    end
  end
end
