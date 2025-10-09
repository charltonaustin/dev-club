class TasksController < ApplicationController
  def index
    tasks = GetTasks.call
    render json: tasks
  end

  def create
    saved_tasks = SaveTasks.call([task_params])

    render json: saved_tasks, status: :created
  end

  def update
    unless task_params[:completed].present? or task_params[:name].present?
      render json: { message: "No changes sent" }
      return
    end
    
    task = UpdateTask.call(params[:id], task_params[:completed], task_params[:name])
    
    render json: task
  end

  private

  def task_params
    params.permit(:name, :id, :completed)
  end
end
