require_relative 'spec_helper'
require_relative '../src/deck'

describe Deck do
  context "state based" do
    it "creates 52 new cards" do
      deck = Deck.new

      expect(deck.cards.count).to eq(52)
    end

    context "shuffle_deck" do
      it "shuffles deck" do
        deck = Deck.new

        initial_cards = deck.cards.dup

        deck.shuffle_deck

        expect(initial_cards).not_to eq(deck.cards)
      end
    end
  end

  context "collaboration based" do
    it "creates 52 new cards" do
      deck = Deck.new

      expect(deck.cards[0].class.name).to eq("Card")
    end

    context "shuffle_deck" do
      it "shuffles deck" do
        deck = Deck.new

        deck.shuffle_deck

        expect(deck.cards).to have_received(:shuffle!)
      end
    end
  end
end
