class Post < ApplicationRecord
  include Attachable, Commentable, Notificable, Likeable

  belongs_to :user

  validates :body, presence: true
  validates :attachment, presence: true

  scope :for_followers_and_user, ->(user) { where("posts.user_id IN (#{user.followed_users.select("followee_id").to_sql}) OR posts.user_id = #{user.id}") }
  scope :user_likes, ->(user) {
    where("likes.user_id = ?", user.id).
      select("posts.id as post_id, COUNT(likes.id) as current_user_like").
        group("posts.id").count
  }


  def user_ids
    user.following_users.pluck("follower_id").uniq
  end
end
