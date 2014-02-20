class Poll < ActiveRecord::Base
	belongs_to :expert_user, class_name: "User"
	has_many :questions, dependent: :destroy
	
	#has_and_belongs_to_many :participants, class_name: "User", foreign_key: "user_id", association_foreign_key: "poll_id"
	has_many :user_poll_relationships
	has_many :participants, through: :user_poll_relationships, source: :user

	validates :title, presence: true
	validates :finished, presence: true
end
