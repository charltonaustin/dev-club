require_relative '../src/deck'
require_relative '../src/card'

# frozen_string_literal: true

describe Deck do
  subject { described_class.new }

  describe "State Based Tests" do

    it "has 52 cards" do
      expect(subject.cards.length).to eq(52)
    end

    # We think it's impossible to write (non-flakey) a state based test around shuffling
    # describe "#shuffle_deck" do
    #   it "changes the order of the cards" do
    #     expect(subject.cards).not_to eq(subject.shuffle_deck)
    #   end
    # end
  end

  describe "Interaction Based Tests" do
    it "shuffles the cards in the initilizer" do
      cards_double = double("Cards")
      allow_any_instance_of(Deck).to receive(:@cards).and_return(cards_double)
      expect(cards_double).to receive(:shuffle!)
      subject
    end

    it "gives you a single card" do
      expect(subject.deal_card).to be_a(Card)
    end

    describe "shuffle_deck" do
      let(:cards_double) { double("Cards") }

      before do
        allow(cards_double).to receive(:shuffle!)
      end

      it "calls shuffle on the array of cards" do
        subject.cards = cards_double
        expect(cards_double).to receive(:shuffle!)
        subject.shuffle_deck
      end
    end
  end
end
