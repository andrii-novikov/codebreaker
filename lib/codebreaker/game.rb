module Codebreaker
  class Game
    ATTEMPTS = 10
    SCORE_FILE_NAME = '.score'
    HINTS = 2
    attr_accessor :name
    attr_reader :attempts, :hints, :status

    def initialize
      @name = nil
      @status = nil
      start
    end

    def start
      @code = generate
      @attempts = ATTEMPTS
      @hints = HINTS
      @status = :play
    end

    def check(guess)
      @attempts -= 1
      return game_over unless attempts > 0
      return game_over(true) if guess.to_s == @code
      raise ArgumentError.new('Guess must have 4 numbers from 1 to 6') if !valid_code?(guess)
      @guess_code = [guess.to_s.chars, @code.dup.chars]
      ans = ''
      ans << check_for_plus
      ans << check_for_minus
      ans
    end

    def game_over(win = false)
      @status = win ? :win : :lose
    end

    def valid_code?(code)
      !(/^[1-6]{4}$/ =~ code.to_s).nil?
    end

    def generate
      (1..4).map {1+rand(6)}.join
    end

    def hint
      return false unless hints > 0
      @hints-=1
      @code.chars.sample
    end

    def save
      unless File.exist? SCORE_FILE_NAME
        File.write(SCORE_FILE_NAME,"name\tattempts\thints\tstatus\r\n")
      end
      unless name.nil?
        data = "#{name}\t#{ATTEMPTS-attempts}\t#{HINTS-hints}\t#{@status}"
        File.open(SCORE_FILE_NAME,'a') {|f| f.puts(data)}
      end
    end

    def score
      File.read(SCORE_FILE_NAME) if File.exist? SCORE_FILE_NAME
    end

    private
    def check_for_plus
      ans = ""
      transponse_code
      @guess_code.delete_if do |pair|
        if pair[0]==pair[1]
          ans << '+'
          true
        end
      end
      transponse_code
      ans
    end

    def transponse_code
      @guess_code = @guess_code.transpose
    end

    def check_for_minus
      ans = ''
      guess, code = @guess_code
      guess.each_with_index do |g,i|
        if code.include? g
          ans << '-'
          code.delete_at(code.index(g))
        end
      end
      ans
    end
  end
end
