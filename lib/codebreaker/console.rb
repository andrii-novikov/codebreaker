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
      say status
      game.save if ask :save?
      ask(:play_again?) ? new_game : say(:goodby)
    end

    def messages
      {
          win: 'You win!',
          lose: 'Game over, you are lose.',
          play_again?: 'Do you want play again?(yes/no)',
          again?: 'Do you want play again?(yes/no)',
          save?: 'Do you want to save result?(yes/no)',
          goodby: "Goodby #{game.name}"
      }
    end

    def say(message)
      if messages.has_key? message
        puts messages[message]
        true
      else
        false
      end
    end

    def ask(question)
      ['yes','y'].include? gets.chomp if say question
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
