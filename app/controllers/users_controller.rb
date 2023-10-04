class UsersController < ApplicationController
	def index
		@users = User.all_except(current_user)
		@followed_users = current_user.followed_users.
												where("followee_id IN (#{@users.select("id").to_sql})").
													pluck(:followee_id)
	end

	def follow
		followed = current_user.followed_users.find_by_followee_id(params[:id])
    if followed
      followed.destroy!
      respond_to do |format|
        format.json { render json: { followed: false } }
      end
    else
      current_user.followed_users.build(followee_id: params[:id]).save!
      respond_to do |format|
        format.json { render json: { followed: true } }
      end
    end 
	end
end
