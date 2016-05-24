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
      say(get_choice) while game.status == :play
      game.save if ask :save?
      if ask(:play_again?)
        new_game
      else
        say(:scores)
        say(:goodby)
      end
    end

    def messages
      {
          win: 'You win!',
          lose: 'Game over, you are lose.',
          play_again?: 'Do you want play again?(yes/no)',
          again?: 'Do you want play again?(yes/no)',
          save?: 'Do you want to save result?(yes/no)',
          scores: "BEST SCORES\n#{game.score}",
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

    def get_choice
      puts 'Enter your choice:'
      choice = gets.chomp
      case
      when game.valid_code?(choice)
        check choice
      when ['q','quit'].include?(choice)
        game.game_over
      when ['h','hint'].include?(choice)
        hint
      when 'help' == choice
        puts help
      else
        print "Wrong code. "
        get_choice
      end
    end

    def help
      File.read('help')
    end

    def check(choice)
      answer = game.check(choice)
      answer = 'Nothing matched' if answer.empty?
      puts "answer: #{answer}. #{game.attempts} attempts left" if game.status == :play
      answer
    end

    def hint
      hint = game.hint
      puts "Code containe #{hint}" if hint
      puts "You have #{game.hints} hints"
    end
  end

end
