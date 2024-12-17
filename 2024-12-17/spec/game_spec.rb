require_relative '../src/game.rb'

describe Game do
  context 'interaction based' do
    context 'start_game' do
      it 'should put out correct text' do
        expect do
          Game.new.start_game
        end.to output('Shuffled deck and ready to play.
').to_stdout  
      end
    end
  end
  
  context 'state based' do
    
  end
end