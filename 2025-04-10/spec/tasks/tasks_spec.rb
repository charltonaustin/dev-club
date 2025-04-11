# frozen_string_literal: true

require 'rspec'
require_relative '../../lib/tasks/tasks'

RSpec.describe 'Tasks' do
  context 'when condition' do
    it 'succeeds' do
      # create a new instance
      # ownership of a collection of tasks
      # add a task to it
      tasks = Tasks.new
      allow($stdout).to receive(:puts)
      allow($stdin).to receive(:getc).and_return('y')
      tasks.create_a_task("description", false, [])
      tasks.list
      expect($stdout).to have_received(:puts).with("slime")
    end
  end
end
