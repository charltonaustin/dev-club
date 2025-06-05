# frozen_string_literal: true

require_relative '../lib/main_screen'

describe 'MainScreen' do
  before do
    allow($stdin).to receive(:getc).and_return("\n")
    allow($stdout).to receive(:puts)
    allow_any_instance_of(Kernel).to receive(:system)
  end

  it 'should create a task' do
    allow($stdin).to receive(:gets).and_return("1\n", "Task name 1\n", "9\n")
    tasks = []
    begin
      MainScreen.new(tasks).do
    rescue SystemExit => e
      # Ignored
    end
    expect(tasks[0].description).to eq("Task name 1")
    expect(tasks[0].completed).to eq(false)
    expect(tasks[0].history).to eq(["Task name 1"])
  end

  it 'should list all task' do
    allow($stdin).to receive(:gets).and_return("2\n", "9\n")
    begin
      MainScreen.new([Task.new("Task name 1", false, []), Task.new("Task name 2", false, [])]).do
    rescue SystemExit => e
      # Ignored
    end
    expect($stdout).to have_received(:puts).with("1. [ ] Task name 1").exactly(1)
    expect($stdout).to have_received(:puts).with("2. [ ] Task name 2").exactly(1)
  end
  it 'should edit a task' do
    allow($stdin).to receive(:gets).and_return("5\n", "1\n", "Task name 1 v 1\n", "9\n")
    tasks = [Task.new("Task name 1", false, [])]
    begin
      MainScreen.new(tasks).do
    rescue SystemExit => e
      # Ignored
    end
    expect(tasks[0].description).to eq("Task name 1 v 1")
  end

  it 'should view a task history' do
    allow($stdin).to receive(:gets).and_return("6\n", "1\n", "9\n")
    tasks = [Task.new("Task name 1 v 1", false, ["slime", "Task name 1 v 1"])]
    begin
      MainScreen.new(tasks).do
    rescue SystemExit => e
      # Ignored
    end
    expect($stdout).to have_received(:puts).with("1. slime").exactly(1)
  end

  it 'should revert a task to a previous version' do
    allow($stdin).to receive(:gets).and_return("7\n", "1\n", "1\n", "9\n")
    tasks = [Task.new("Task name 1 v 1", false, ["task name 1"])]
    begin
      MainScreen.new(tasks).do
    rescue SystemExit => e
      # Ignored
    end
    expect(tasks[0].description).to eq("task name 1")
  end

  it 'should complete a task' do
    allow($stdin).to receive(:gets).and_return("8\n", "1\n", "9\n")
    tasks = [Task.new("Task name 1", false, [])]
    begin
      MainScreen.new(tasks).do
    rescue SystemExit => e
      # Ignored
    end
    expect(tasks[0].completed).to eq(true)
  end
end
