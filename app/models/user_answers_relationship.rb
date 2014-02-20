class UserAnswersRelationship < ActiveRecord::Base
	belongs_to :user, class_name: "User"
  	belongs_to :answer, class_name: "Answer"
  	validates :user_id, presence: true
  	validates :answer_id, presence: true
end
