# frozen_string_literal: true

require_relative '../app/important_consumer'
describe 'Important Consumer' do
  it 'can creates and get a user' do
    VCR.use_cassette('important_producer') do
      expect(ImportantConsumer.new.create_user[:success?]).to be(true)
      expect(ImportantConsumer.new.get_user[:first_name]).to eq('First')
      expect(ImportantConsumer.new.get_user[:family_name]).to eq('Last')
    end
  end
end
