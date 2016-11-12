class TasksController < ApplicationController
  before_action :normalize_params, only: :update

  def index
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    render(:new) unless @task.save
  end

  def update
    @task = Task.find(params[:id])
    @task.update(task_params)
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update_all
    Task.update_all(done: params[:done].present?)
    head :ok, content_type: 'text/html'
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
  end

  def remove_completed
    Task.where(done: true).delete_all
  end

  private

  def normalize_params
    params[:task] ||= { done: false }
  end

  def task_params
    params.fetch(:task).permit(:title, :done)
  end

  def tasks
    @tasks ||= Task.filtered(params[:type]).order(id: :desc)
  end

  helper_method :tasks
end
