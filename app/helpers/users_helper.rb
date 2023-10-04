module UsersHelper
	def follow_user? id
		@followed_users.include?(id) ? 'Unfollow' : 'Follow'
	end
end
