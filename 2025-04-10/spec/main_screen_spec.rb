# frozen_string_literal: true

require 'rspec'
require_relative '../lib/main_screen'

RSpec.describe 'MainScreen' do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  context 'when condition' do
    it 'succeeds' do

      allow($stdin).to receive(:gets).and_return("1\n",
                                                 "Task name 1\n",
                                                 "4\n",
                                                 "1\n",
                                                 "Task name 1 v 1\n",
                                                 "5\n",
                                                 "1\n",
                                                 "6\n",
                                                 "1\n",
                                                 "2\n",
                                                 "3\n",
                                                 "3\n",
                                                 "3\n")
      allow($stdin).to receive(:getc).and_return("\n")
      allow($stdout).to receive(:puts)
      begin
        MainScreen.new([]).do
      rescue SystemExit => e
        # Ignored
      end
      expect($stdout).to have_received(:puts).with("\nWhat would you like to do?").exactly(5)
      expect($stdout).to have_received(:puts).with("1. Create a task").exactly(5)
      expect($stdout).to have_received(:puts).with("2. List tasks").exactly(5)
      expect($stdout).to have_received(:puts).with("3. Exit").exactly(5)
      expect($stdout).to have_received(:puts).with("4. Edit a task").exactly(5)
      expect($stdout).to have_received(:puts).with("5. View task history").exactly(5)
      expect($stdout).to have_received(:puts).with("6. Revert to previous version").exactly(5)
      expect($stdout).to have_received(:puts).with("Enter the task description:").exactly(1)
      expect($stdout).to have_received(:puts).with("Task added: Task name 1").exactly(1)
      expect($stdout).to have_received(:puts).with("--- Your Todo List ---").exactly(3)
      expect($stdout).to have_received(:puts).with("1. [ ] Task name 1").exactly(1)
      expect($stdout).to have_received(:puts).with("-----------------------").exactly(3)
      expect($stdout).to have_received(:puts).with("Enter the number of the task you want to edit:").exactly(1)
      expect($stdout).to have_received(:puts).with("Enter the new description for the task:").exactly(1)
      expect($stdout).to have_received(:puts).with("Task 1 updated to: Task name 1 v 1").exactly(1)
      expect($stdout).to have_received(:puts).with("1. [ ] Task name 1 v 1").exactly(2)
      expect($stdout).to have_received(:puts).with("Enter the number of the task whose history you want to view:").exactly(2)
      expect($stdout).to have_received(:puts).with("--- Task 1 History ---").exactly(2)
      expect($stdout).to have_received(:puts).with("1. Task name 1").exactly(2)
      expect($stdout).to have_received(:puts).with("2. Task name 1 v 1").exactly(2)
      expect($stdout).to have_received(:puts).with("--------------------------").exactly(2)
      expect($stdout).to have_received(:puts).with("Press enter to continue").exactly(1)
      expect($stdout).to have_received(:puts).with("Enter the number of the previous version you want to revert to:").exactly(1)
      expect($stdout).to have_received(:puts).with("Task 1 reverted to version 2: Task name 1 v 1").exactly(1)
      expect($stdout).to have_received(:puts).with("Exiting todo app. Goodbye!").exactly(1)

    end
  end
end
