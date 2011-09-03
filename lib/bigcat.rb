module BigCat
  class String
    def initialize(string)
      @string = string
    end

    def big_top_half
      if @string == "\n" || @string == ""
        @string
      else
        "\e#3#{@string}"
      end
    end

    def big_bottom_half
      if @string == "\n" || @string == ""
        @string
      else
        "\e#4#{@string}"
      end
    end
  end

  class Formatter
    attr_reader :output

    def initialize(output)
      @output = output
    end

    def write(string)
      string = String.new(string)
      output.puts(string.big_top_half)
      output.puts(string.big_bottom_half)
      output.flush
    end
  end

  class Command
    attr_accessor :formatter
    attr_reader :streams

    class << self
      def run!(arguments, input, output)
        status = false
        inst = self.new

        if arguments.empty?
          inst.add_stream(input)
        else
          status = arguments.collect { |arg|
            inst.add_file(arg)
          }.any? { |arg| arg == false }
        end

        inst.formatter = BigCat::Formatter.new(output)
        inst.run!

        status
      end
    end

    def initialize
      @streams = Array.new
    end

    def add_stream(io)
      @streams << io
    end

    def add_file(path)
      if File.file?(path)
        add_stream(File.open(path, 'r'))
        true
      else
        $stderr.puts "No such file: #{path}"
        false
      end
    end

    def run!
      @streams.each { |io|
        read(io)
      }
    end

    private

    def read(stream)
      stream.each_line do |line|
        formatter.write(line)
      end

      stream.close
    end

    def read_file(path)
      File.open(path, 'r') do |f|
        read_stream(f)
      end

      return true
    rescue Errno::ENOENT, Errno::EISDIR
      return false
    end
  end
end
