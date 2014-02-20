class Answer < ActiveRecord::Base
	validates :content, presence: true
	belongs_to :question
	has_many :user_answers_relationships
	has_many :responders, through: :user_answers_relationships, source: :user

	def chosen_by?(user)
		user_answers_relationships.find_by(user_id: user.id)
	end

	def be_chosen_by!(user)
		user_answers_relationships.create!(user_id: user.id)
	end

	def be_not_chosen_by!(user)
		user_answers_relationships.find_by(user_id: user.id).destroy
	end
end
