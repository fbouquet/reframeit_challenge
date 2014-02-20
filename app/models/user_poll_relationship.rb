class UserPollRelationship < ActiveRecord::Base
	belongs_to :user, class_name: "User"
  	belongs_to :poll, class_name: "Poll"
  	validates :user_id, presence: true
  	validates :poll_id, presence: true
end
