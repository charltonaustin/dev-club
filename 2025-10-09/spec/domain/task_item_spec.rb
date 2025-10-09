require 'spec_helper'
require_relative '../../app/domain/task_item'

RSpec.describe TaskItem do
  it 'starts incomplete' do
    task = TaskItem.new(name: 'Buy milk')
    expect(task.completed?).to eq(false)
  end

  it 'can be marked complete' do
    task = TaskItem.new(name: 'Wash car')
    task.complete!
    expect(task.completed?).to eq(true)
  end

  it 'can be reopened' do
    task = TaskItem.new(name: 'Study')
    task.complete!
    task.reopen!
    expect(task.completed?).to eq(false)
  end

  it 'can be reopened' do
    task = TaskItem.new(name: 'Study')
    task.update_name("completed task")
    
    expect(task.name).to eq('Study')
  end
end