describe 'bigcat' do
  let!(:bigcat) { Pathname.new(__FILE__).parent.parent.parent.join('bin', 'bigcat') }

  def run(&block)
    IO.popen(bigcat, 'r+') do |io|
      if block
        block.call(io)
      else
        io.close
      end
    end

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
        run do |io|
          io.puts("")
          io.read(2).should == "\n\n"
        end
      end

      it "exits on EOF" do
        ret = run do |io|
          io.puts
          io.read(2)
          io.close
        end
        ret.should == 0
      end
    end

    context 'multiple newlines' do
      it "writes two empty lines for each line" do
        run do |io|
          io.write("\n\n\n")
          io.read(6).should == "\n\n\n\n\n\n"
        end
      end
    end

    context 'line with characters' do
      let!(:string) { "Hello" }

      it "writes the line as two lines wrapped with VT100's top half double sized escape" do
        run do |io|
          io.puts(string)
          io.readline.should == "\e#3#{string}\n"
          io.readline.should == "\e#4#{string}\n"
        end
      end

      it "is waiting for more input" do
        run do |io|
          io.puts(string)
          io.readline
          io.readline

          io.puts(string)
          io.readline.should_not be_empty
        end
      end
    end

    context 'multiple lines before EOF' do
      it "writes each line wrapped as line pairs with VT100's double size escape sequences" do
        run do |io|
          io.puts("hello")
          io.puts("world")

          io.readline.should == "\e#3hello\n"
          io.readline.should == "\e#4hello\n"
          io.readline.should == "\e#3world\n"
          io.readline.should == "\e#4world\n"
        end
      end
    end
  end
end