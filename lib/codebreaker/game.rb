module Codebreaker
  class Game
    
    attr_accessor :name
    attr_reader :attempts, :hints, :status, :default, :history

    def initialize(name = nil, attempts = 10, hints = 2, score_file_name = '.score')
      @name = name
      @status = nil
      @default = {attempts: attempts, hints: hints, score_file_name: score_file_name}
      @history = []
      start
    end

    def start
      @code = generate
      @attempts = default[:attempts]
      @hints = default[:hints]
      @status = :play
    end

    def check(guess)
      raise ArgumentError.new('Guess must have 4 numbers from 1 to 6') if !valid_code?(guess)
      @attempts -= 1
      return game_over(true) if guess.to_s == @code
      return game_over unless attempts > 0
      answer = get_answer guess
      history << [guess,answer]
      answer
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
      unless File.exist? default[:score_file_name]
        File.write(default[:score_file_name],"name\tattempts\thints\tstatus\r\n")
      end
      unless name.nil?
        data = "#{name}\t#{default[:attempts]-attempts}\t#{default[:hints]-hints}\t#{status}"
        File.open(default[:score_file_name],'a') {|f| f.puts(data)}
      end
    end

    def score
      File.read(default[:score_file_name]) if File.exist? default[:score_file_name]
    end

    def in_play?
      status == :play
    end

    def win?
      status == :win
    end

    def lose?
      status == :lose
    end

    private
    def get_answer(guess)
      guess = guess.to_s.chars
      code = @code.dup.chars
      guess, code, ans = check_for_plus(guess,code)
      ans << check_for_minus(guess,code)
    end
    def check_for_plus(guess, code)
      ans = ''
      guess, code = [guess,code].transpose.delete_if do |pair|
        ans << '+' if pair.uniq.size == 1
      end.transpose
      [guess,code,ans]
    end

    def check_for_minus(guess,code)
      ans = ''
      guess.each do |g|
        index = code.index(g)
        next if index.nil?
        ans << '-'
        code.delete_at(index)
      end
      ans
    end
  end
end
