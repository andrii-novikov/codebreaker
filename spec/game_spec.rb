require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    let(:game) {Game.new}
    describe '#start' do
      it 'generates a secret code' do
        expect(game.instance_variable_get(:@code)).not_to be_empty
      end
      it 'set status to :play' do
        expect(game.status).to eq :play
      end
    end

    describe "#generate" do
      it 'sectet code with 4 numbers' do
        expect(game.instance_variable_get(:@code).size).to eq 4
      end
      it 'secret code with numbers 1 to 6' do
        expect(game.valid_code? game.generate).to eq true
      end
      it 'different codes each time' do
        expect(game.generate).not_to eq game.generate
      end
    end

    describe '#game_over' do
      it 'return :lose with any args' do
        expect(game.game_over).to eq :lose
      end
      it 'return :win with arg' do
        expect(game.game_over true).to eq :win
      end
    end

    describe '#check_guess' do
      before {allow_any_instance_of(Game).to receive(:generate).and_return('1234')}
      context 'if guess' do
        it 'equal secret then answer with ++++' do
          expect(game.check "1234").to eq :win
        end
        it 'has numbers form secret then answer contained + or -' do
          expect(game.check "1111").to eq "+"
        end
        it 'haven\'t numbers from secret then answer with nothing matched' do
          expect(game.check "6666").to eq ''
        end
      end
      it 'decrease attemps number' do
        expect {game.check "1232"}.to change {game.attempts}.by(-1)
      end
      it 'answer with lose if run out attempt' do
        allow(game).to receive(:attempts).and_return(0)
        expect(game.check "1234").to eq :lose
      end
    end

    describe '#hint' do
      it 'give one number' do
        expect(game.hint.size).to eq 1
      end
      it 'contains in secret code' do
        expect(game.instance_variable_get(:@code)).to include game.hint
      end
    end

    describe "#save" do
      before do
        File.write('dump',File.read('score')) if File.exist? 'score'
      end
      after do
        if File.exist? 'dump'
          File.write('score',File.read('dump'))
          File.delete('dump')
        else
          File.delete 'score' if File.exist? 'score'
        end
      end
      it "shoud create file" do
        game.instance_variable_set(:@name, 'test')
        game.save
        expect(File.exist? 'score').to eq true
      end
      it 'shoud change size by 1' do
        game.instance_variable_set(:@name, 'test')
        expect {game.save}.to change {File.read('score').lines.count}.by(1)
      end
    end
  end
end