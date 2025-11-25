require_relative '../src/card'

RSpec.describe Card do
  let(:card) { Card.new('Hearts', 'King') }

  it 'initializes with a suit and value' do
    expect(card.suit).to eq('Hearts')
    expect(card.value).to eq('King')
  end

  it 'allows suit and value to be updated' do
    card.suit = 'Diamonds'
    card.value = 'Ace'

    expect(card.suit).to eq('Diamonds')
    expect(card.value).to eq('Ace')
  end

  it 'formats the card as a string' do
    expect(card.to_s).to eq('King of Hearts')
  end
end
