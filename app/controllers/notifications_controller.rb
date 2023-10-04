class NotificationsController < ApplicationController

  def index
    @notifications = current_user.notifications.
    									includes(item: [:user, :likeable]).
    										order(created_at: :desc)
    @notifications.update_all(viewed: true)
  end
end

