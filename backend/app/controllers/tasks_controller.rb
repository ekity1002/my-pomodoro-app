class TasksController < ApplicationController
  # GET /tasks
  def index
    @tasks = Task.all
    render json: @tasks
  end

  def show
    task = Task.find(params[:id])
    render json: task
  end

  def create
    task = Task.new(task_params)
    begin
      if task.save
        render json: task, status: :created
      else
        render json: task.errors, status: :unprocessable_entity
      end
    rescue
      render json: task.errors, status: :unprocessable_entity
    end
  end

  private
    def task_params
      params.require(:task).permit(:title, :description, :due_date, :project_id)
    end
end
