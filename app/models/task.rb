class Task
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :description, type: String
  field :status, type: String, default: 'New'
  field :is_active, type: Boolean, default: true

  after_create -> { TaskBroadcaster.broadcast_task(self, action: :create) }
  after_update -> { TaskBroadcaster.broadcast_task(self, action: :update) }
end
