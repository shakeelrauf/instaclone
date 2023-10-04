class Notification < ApplicationRecord
  belongs_to :item, polymorphic: true
  belongs_to :user

  scope :unviewed, ->{ where(viewed: false) }
  scope :latest, ->{ order("created_at DESC") }

  default_scope { latest }

  after_create_commit do 
    broadcast_prepend_to "broadcast_to_user_#{self.user_id}", 
      target: :notifications
  end

  after_update_commit do 
    broadcast_replace_to "broadcast_to_user_#{self.user_id}", 
      target: self
  end

  after_destroy_commit do 
    broadcast_remove_to "broadcast_to_user_#{self.user_id}", 
      target: :notifications
  end

  after_commit do
    broadcast_replace_to "broadcast_to_user_#{self.user_id}", 
      target: "notifications_count", 
      partial: "notifications/count", 
      locals: { count: self.user.unviewed_notifications_count }
  end
end
