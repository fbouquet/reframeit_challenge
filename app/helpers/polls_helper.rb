module PollsHelper
	def current_user_can_respond_to(poll)
		unless poll.finished? or (signed_in? and current_user.responded_to?(poll))
			return true
		end
	end

	def current_user_can_end(poll)
		!poll.finished? and signed_in? and poll.expert_user == current_user and current_user.responded_to?(poll)
	end

	def parse_datetime_select(poll_params)
		DateTime.new(poll_params["ends_at(1i)"].to_i, 
                    	poll_params["ends_at(2i)"].to_i,
                    	poll_params["ends_at(3i)"].to_i,
                    	poll_params["ends_at(4i)"].to_i,
                    	poll_params["ends_at(5i)"].to_i)
	end
end
