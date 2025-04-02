class TasksController < ApplicationController
  include ActionView::RecordIdentifier # This enables dom_id in the controller
  before_action :set_task, only: [:edit, :update, :destroy, :change_status]

  def index
    @tasks = Task.all
    @inprogress_tasks = @tasks.where(status: 'progress')
    @completed_tasks = @tasks.where(status: 'completed')
    @new_tasks = @tasks.where(status: 'New')
  end

  def show
    @task = Task.find(params[:id])
    @task.update(status: "progress") # Update status to "old"
    Turbo::StreamsChannel.broadcast_update_to("tasks", target: "task_status_#{@task.id.to_s}", html: @task.status)
    update_count
    respond_to do |format|
      format.html # This will render `show.html.erb`
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("task_status_#{@task.id.to_s}", partial: "tasks/status", locals: { task: @task })
      end
    end
  end



  def create
    @task = Task.new(task_params)
    @tasks = Task.all
    if @task.save

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("tasks", partial: "tasks/task", locals: { task: @task })
            # turbo_stream.replace("count_task", @tasks.count + 1)
          ]
        end
        format.html { redirect_to tasks_path, notice: "task created successfully!" }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def update
    if @task.update(task_params)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@task) }
        format.html { redirect_to tasks_path, notice: "task updated!" }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    Turbo::StreamsChannel.broadcast_remove_to("tasks", target: dom_id(@task))
    Turbo::StreamsChannel.broadcast_update_to("tasks", target: "count_task", html: Task.count.to_s)
    Turbo::StreamsChannel.broadcast_append_to(
      "notifications",
      target: "notifications",
      partial: "shared/notification",
      locals: { message: "Task deleted successfully!" }
    )
    update_count
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@task) }
      format.html { redirect_to tasks_path, notice: "task deleted!" }
    end
  end

  def change_status
    @task = Task.find(params[:id])
    @task.update(status: @task.status == "progress" ? "completed" : "progress")
    Turbo::StreamsChannel.broadcast_update_to("tasks", target: "task_status_#{@task.id.to_s}", html: @task.status)
    update_count
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@task, partial: "tasks/task", locals: { task: @task })
      end
      format.html { redirect_to tasks_path, notice: "Task status updated." }
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description)
  end

  def update_count
    @tasks = Task.all
    @inprogress_tasks = @tasks.where(status: 'progress')
    @completed_tasks = @tasks.where(status: 'completed')
    @new_tasks = @tasks.where(status: 'New')
    Turbo::StreamsChannel.broadcast_update_to("tasks", target: "new_task_count", html: @new_tasks.count)
    Turbo::StreamsChannel.broadcast_update_to("tasks", target: "inprogress_task_count", html: @inprogress_tasks.count)
    Turbo::StreamsChannel.broadcast_update_to("tasks", target: "completed_task_count", html: @completed_tasks.count)
  end
end
