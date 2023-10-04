class Like < ApplicationRecord
  include Notificable
  belongs_to :likeable, polymorphic: true, counter_cache: true
  belongs_to :user

  def user_ids
    self.likeable.user.following_users.pluck("followee_id").uniq
  end
end
