ENV['APP_ENV'] = 'test'
require_relative './shared'

describe 'GET users' do
  it 'run contract tests' do
    contract_test
  end
end
