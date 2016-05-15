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
      before(:each) do
        allow(console.game).to receive(:status).and_return(:play,:win)
        allow(console).to receive(:gets) {'no'}
        allow(console).to receive(:get_choice).and_return(:win)
      end
      it 'show message You win! when you win', :wined do
        expect {console.new_game}.to output(/win/i).to_stdout
      end
      it 'show message game over when you lose' do
        allow(console).to receive(:get_choice) {:lose}
        expect {console.new_game}.to output(/lose/i).to_stdout
      end
      it 'propose to save and play again' do
        allow(console).to receive(:puts)
        expect(console).to receive(:ask).with(:save?).once
        expect(console).to receive(:ask).with(:play_again?).once
        console.new_game
      end
      it 'when play again start new game' do
        allow(console).to receive(:puts)
        allow(console).to receive(:gets).and_return('yes','yes','no')
        expect(console).to receive(:new_game).and_call_original.twice
        console.new_game
      end
    end

    context '#get_choice' do
      it 'propose to enter choice' do
        allow(console).to receive(:puts)
        expect(console).to receive(:gets){'q'}.once
        console.get_choice
      end
      it 'when h or hint take a hint' do
        allow(console).to receive(:gets){'h'}.once
        expect(console.game).to receive(:hint)
        expect{console.get_choice}.to output(/\d hints/).to_stdout
      end
      it 'when q or quit game over' do
        allow(console).to receive(:puts)
        allow(console).to receive(:gets){'q'}.once
        expect(console.get_choice).to eq :lose
      end
      it 'when valide code puts answer' do
        allow(console).to receive(:gets){'1234'}.once
        expect{console.get_choice}.to output(/answer/).to_stdout
      end
    end
  end
end