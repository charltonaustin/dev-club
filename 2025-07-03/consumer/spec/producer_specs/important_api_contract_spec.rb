# frozen_string_literal: true

require_relative './to_share'

describe 'Contract Tests' do
  it 'verify keys for contract' do
    VCR.use_cassette('important_producer', &method(:contract_test))
  end
end
