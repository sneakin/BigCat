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
    attr_reader :input, :formatter

    def initialize(input, formatter)
      @input = input
      @formatter = formatter
    end

    def run!
      @formatter.write(input.readline) while true
    rescue EOFError
    end
  end
end
