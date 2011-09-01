module BigCat
  class Command
    def initialize()
    end

    def run!
      begin
        line = $stdin.readline
        if line == "\n"
          $stdout.puts("\n\n")
        else
          $stdout.puts("\e#3#{line}\e#4#{line}")
        end
        $stdout.flush
      end while true
    rescue EOFError
    end
  end
end
