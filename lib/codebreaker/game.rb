module Codebreaker
  class Game

    attr_accessor :name, :attempts, :hints

    def initialize
      @name = nil
      start
    end

    def start
      @code = generate
      @attempts = 10
      @hints = 2
    end

    def check(guess)
      return game_over if attempts == 0
      raise ArgumentError.new('Guess must have 4 numbers from 1 to 6') if !valid_code?(guess)
      @attempts -= 1
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
      win ? :win : :lose
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
  end
end
