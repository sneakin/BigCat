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

  class Command
    attr_reader :input, :output

    def initialize(input = $stdin, output = $stdout)
      @input = input
      @output = output
    end

    def write(string)
      string = String.new(string)
      output.puts(string.big_top_half)
      output.puts(string.big_bottom_half)
      output.flush
    end

    def run!
      write(input.readline) while true
    rescue EOFError
    end
  end
end
