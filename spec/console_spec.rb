require 'spec_helper'

module Codebreaker
  RSpec.describe Console do
    let(:console ) {Console.new}
    context '#play' do
      before do
        allow(console).to receive(:gets).and_return('an','1234')
      end
      it 'shoud write welcome' do
        expect {console.play}.to output(/welcome/i).to_stdout
      end
      it 'shoud ask name' do
        expect {console.play}.to output(/name/).to_stdout
      end
      it 'shoud save name into the game' do
        allow(console).to receive(:puts)
        console.play
        expect(console.game.name).to eq 'an'
      end
    end

    context '#new_game' do
      it 'show message You win! when you win' do
        allow(console).to receive(:get_choise) {:win}
        allow(console).to receive(:gets) {'no'}
        expect {console.new_game}.to output(/win/i).to_stdout
      end
      it 'show message game over when you lose' do
        allow(console).to receive(:get_choise) {:lose}
        allow(console).to receive(:gets) {'no'}
        expect {console.new_game}.to output(/lose/i).to_stdout
      end
      it 'propose to play again' do
        allow(console).to receive(:gets) {'no'}
        [:win,:lose].map do |state|
          allow(console).to receive(:get_choise).and_return(state)
          expect {console.new_game}.to output(/play again/i).to_stdout
        end
      end
      it 'when play again yes, start new game' do
        allow(console).to receive(:gets).and_return('yes','no')
        allow(console).to receive(:get_choise).and_return(:win)
        expect(console).to receive(:new_game).once
        console.new_game
      end
      it 'propose to save a game results'
    end

    context '#get_choice' do
      it 'propose to enter choise' do
        allow(console).to receive(:puts)
        expect(console).to receive(:gets){'q'}.once
        console.get_choise
      end
      it 'when h or hint take a hint' do
        allow(console).to receive(:gets){'h'}.once
        expect(console.game).to receive(:hint)
        expect{console.get_choise}.to output(/\d hints/).to_stdout
      end
      it 'when q or quit game over' do
        allow(console).to receive(:puts)
        allow(console).to receive(:gets){'q'}.once
        expect(console.get_choise).to eq :lose
      end
      it 'when valide code puts answer' do
        allow(console).to receive(:gets){'1234'}.once
        expect{console.get_choise}.to output(/answer/).to_stdout
      end
    end
  end
end