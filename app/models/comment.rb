class Comment < ApplicationRecord
  include Notificable
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  def user_ids
    if self.user_id == self.commentable.user_id
      self.commentable.user_ids
    else
      self.commentable.user.following_users.pluck("followee_id").uniq
    end
  end
end
