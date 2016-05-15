module Codebreaker
  class Console
    attr_accessor :game

    def initialize
      @game = Game.new
    end

    def play
      puts "Welcome to the game codebreaker!\n"
      puts 'Enter your name:'
      game.name = gets.chomp
      new_game
    end

    def new_game
      game.start
      status = get_choise until [:win,:lose].include? status
      puts messages[status]
      if gets.chomp == 'yes'
        new_game
      else
        puts game.name.nil? ? 'Goodby' : "Goodby #{game.name.capitalize}"
      end
    end

    def messages
      {
          win: "You win! Do you want play again?(yes/no)",
          lose: "Game over, you are lose. Do you want play again?(yes/no)"
      }
    end

    def get_choise
      puts 'Ener your choise:'
      ans = gets.chomp
      if game.valid_code? ans
        status = game.check(ans)
        status = 'Nothing matched' if status.empty?
        puts "answer: #{status}. You have #{game.attempts} attempts" unless status == :win
        status
      elsif ans == 'q' || ans == 'quit'
        :lose
      elsif ans == 'h' || ans == 'hint'
        hint = game.hint
        puts "Code containe #{hint}" if hint
        puts "You have #{game.hints} hints"
      elsif ans == 'help'
        puts help
      else
        print "Wrong code. "
        get_choise
      end
    end

    def help
      File.read('help')
    end
  end

end
