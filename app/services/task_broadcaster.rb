class TaskBroadcaster
  def self.broadcast_task(task, action: :create)

    case action
    when :create
      Turbo::StreamsChannel.broadcast_append_to(
        "tasks",
        target: "tasks-list",
        partial: "tasks/task",
        locals: { task: task }
      )
    when :update
      Turbo::StreamsChannel.broadcast_replace_to(
        "tasks",
        target: dom_id(task),
        partial: "tasks/task",
        locals: { task: task }
      )
    end

    broadcast_task_count
    broadcast_task_status(task)
    broadcast_task_notification(action)
  end

  def self.broadcast_task_count
    tasks = Task.all
    Turbo::StreamsChannel.broadcast_update_to("tasks", target: "count_task", html: tasks.count.to_s)
    Turbo::StreamsChannel.broadcast_update_to("tasks", target: "new_task_count", html: tasks.where(status: 'New').count)
  end

  def self.broadcast_task_status(task)
    Turbo::StreamsChannel.broadcast_update_to("tasks", target: "task_status_#{task.id.to_s}", html: task.status)
  end

  def self.broadcast_task_notification(action)
    Turbo::StreamsChannel.broadcast_append_to(
      "notifications",
      target: "notifications",
      partial: "shared/notification",
      locals: { message: "Task #{action}d successfully!" }
    )
  end

  def self.dom_id(record, prefix = nil)
    ActionView::RecordIdentifier.dom_id(record, prefix)
  end
end
