module Codebreaker
  class Game
    ATTEMPTS = 10
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
      raise ArgumentError.new('Guess must have 4 numbers from 1 to 6') if !valid_code?(guess)
      ans = guess.to_s.chars.map.with_index do |number,index|
        if number == @code.chars[index]
          '+'
        elsif @code[index..-1].include? number
          '-'
        else
          ''
        end
      end
      ans.join == "++++" ? game_over(true) : ans.join
    end

    def game_over(win = false)
      @status = win ? :win : :lose
    end

    def valid_code?(code)
      code.to_s.size == 4 && code.to_s.chars.all? {|char| (1..6).include? char.to_i}
    end

    def generate
      code = ''
      4.times {code+=(1+rand(6)).to_s}
      code
    end

    def hint
      if hints > 0
        @hints-=1
        @code[rand(4)]
      end
    end

    def save
      unless name.nil?
        data = {name: name, attempts: ATTEMPTS-attempts, hints: HINTS-hints, status: @status}.inspect
        File.open('score','a') {|f| f.puts(data)}
      end
    end
  end
end
