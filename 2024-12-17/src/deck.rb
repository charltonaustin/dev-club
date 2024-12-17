require_relative 'card'
class Deck
  attr_accessor :cards

  def initialize
    @suits = ['Hearts', 'Diamonds', 'Clubs', 'Spades']
    @values = ['Ace', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King']
    @cards = []
    @suits.each do |suit|
      @values.each do |value|
        @cards << Card.new(suit, value)
      end
    end
    shuffle_deck
  end

  def shuffle_deck
    @cards.shuffle!
  end

  def deal_card
    @cards.pop
  end
end
