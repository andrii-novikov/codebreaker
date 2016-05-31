require 'spec_helper'

module Codebreaker
  RSpec.describe Console do

    context '#play' do
      before do
        allow(subject).to receive(:gets).and_return('an','1234')
      end
      it 'shoud write welcome' do
        expect {subject.play}.to output(/welcome/i).to_stdout
      end
      it 'shoud ask name' do
        expect {subject.play}.to output(/name/).to_stdout
      end
      it 'shoud save name into the game' do
        allow(subject).to receive(:puts)
        subject.play
        expect(subject.game.name).to eq 'an'
      end
    end

    context '#new_game' do
      before(:each) do
        allow(subject.game).to receive(:status).and_return(:play,:win)
        allow(subject).to receive(:gets) {'no'}
        allow(subject).to receive(:get_choice).and_return(:win)
      end
      it 'show message You win! when you win', :wined do
        expect {subject.new_game}.to output(/win/i).to_stdout
      end
      it 'show message game over when you lose' do
        allow(subject).to receive(:get_choice) {:lose}
        expect {subject.new_game}.to output(/lose/i).to_stdout
      end
      it 'propose to save and play again' do
        allow(subject).to receive(:puts)
        is_expected.to receive(:ask).with(:save?).once
        is_expected.to receive(:ask).with(:play_again?).once
        subject.new_game
      end
      it 'when play again start new game' do
        allow(subject).to receive(:puts)
        allow(subject).to receive(:gets).and_return('yes','yes','no')
        is_expected.to receive(:new_game).and_call_original.twice
        subject.new_game
      end
    end

    context '#get_choice' do
      it 'propose to enter choice' do
        allow(subject).to receive(:puts)
        is_expected.to receive(:gets){'q'}.once
        subject.get_choice
      end
      it 'when h or hint take a hint' do
        allow(subject).to receive(:gets){'h'}.once
        expect(subject.game).to receive(:hint)
        expect{subject.get_choice}.to output(/\d hints/).to_stdout
      end
      it 'when q or quit game over' do
        allow(subject).to receive(:puts)
        allow(subject).to receive(:gets){'q'}.once
        expect(subject.get_choice).to eq :lose
      end
      it 'when valide code puts answer' do
        allow(subject).to receive(:gets){'1234'}.once
        expect{subject.get_choice}.to output(/answer/).to_stdout
      end
    end
  end
end