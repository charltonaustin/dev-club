require_relative '../src/card.rb'

describe Card do
  context 'state based' do
    it 'should give back a properly formatted string' do
      expect(Card.new('fake suite', 'fake value').to_s).to eq('fake value of fake suite')
    end
  end
end