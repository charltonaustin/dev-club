require_relative '../src/deck.rb'
describe Deck do
  context 'interaction based' do
    context 'initialize' do
      it 'should call new 52 times' do
        allow(Card).to receive(:new)
        Deck.new
        expect(Card).to have_received(:new).exactly(52).times
      end
    end
    context 'shuffle' do
      it "calls cards.shuffle!" do
        deck = Deck.new
        cards = double("Cards")
        allow_any_instance_of(Deck).to receive(:cards).and_return(cards)
        allow(cards).to receive(:shuffle!)
        deck.shuffle_deck
        expect(cards).to have_received(:shuffle!)
      end
    end

    context 'deal card' do
      it 'should return second card first' do
        first_card = double('First Card')
        second_card = double('Second Card')
        deck = Deck.new
        allow_any_instance_of(Deck).to receive(:cards).and_return([first_card, second_card])
        expect(deck.deal_card).to eq(second_card)
      end
      it 'should return first card second' do
        first_card = double('First Card')
        second_card = double('Second Card')
        deck = Deck.new
        allow_any_instance_of(Deck).to receive(:cards).and_return([first_card, second_card])
        deck.deal_card
        expect(deck.deal_card).to eq(first_card)
      end
      it 'should return nil after all cards are exhausted' do
        deck = Deck.new
        allow_any_instance_of(Deck).to receive(:cards).and_return([double('First Card')])
        deck.deal_card
        expect(deck.deal_card).to be_nil
      end
    end
  end

  context 'state based' do
    context 'initialize' do
      it 'should call create a new deck each time' do
        first_deck = Deck.new
        second_deck = Deck.new
        expect(first_deck.cards).to_not eq(second_deck.cards)
      end
    end

    context 'shuffle' do
      it "should verify that shuffle does not have the same deck " do
        deck = Deck.new
        before_shuffle = deck.cards.dup
        deck.shuffle_deck
        expect(before_shuffle).to_not eq deck.cards
      end
    end
    
    context 'deal card' do
      it 'should return a different card on each invocation' do
        deck = Deck.new
        expect(deck.deal_card).to_not eq deck.deal_card
      end
      it 'should only deal a card once' do
        deck = Deck.new
        first_card = deck.deal_card
        (1..51).each do
          expect(first_card).to_not eq deck.deal_card
        end
      end
      it 'should only deal 52 cards' do
        deck = Deck.new
        (1..52).each do
          deck.deal_card
        end
        expect(deck.deal_card).to be_nil
      end
    end
  end
end