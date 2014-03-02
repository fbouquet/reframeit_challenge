class User < ActiveRecord::Base
	include ApplicationHelper

	before_save { self.email = email.downcase }
	before_create :create_remember_token

	validates :name, presence: true, length: {maximum: 50}
	validates :first_name, presence: true, length: {maximum: 50}

	validates :influence, presence: true, 
		numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, uniqueness: {case_sensitive: false}, format: {with: VALID_EMAIL_REGEX}

	has_secure_password
	validates :password, length: {minimum: 8}


	# Expert user in some polls
	has_many :polls, foreign_key: "expert_user_id"


	# Relationships with Answer
	has_many :user_answers_relationships
	has_many :chosen_answers, through: :user_answers_relationships, source: :answer

	# Relationships history with Answer
	has_many :user_answers_history
	has_many :chosen_answers_history, through: :user_answers_history, source: :answer

	# Relationship with polls into which the user takes part
	has_many :user_poll_relationships
	has_many :answered_polls, through: :user_poll_relationships, source: :poll
	#has_and_belongs_to_many :polls

	def responded_to?(poll)
		user_poll_relationships.find_by(poll_id: poll.id)
	end

	def respond_to!(poll)
		user_poll_relationships.create!(poll_id: poll.id)
	end

	def unrespond_to!(poll)
		user_poll_relationships.find_by(poll_id: poll.id).destroy
	end


	def save_answers_and_respond_to!(poll, question_params)
		poll.questions.each do |question|
			answer_id = question_params["question_" + question.id.to_s + "_answer"]

			unless Answer.find(answer_id).be_chosen_by!(self)
				return false
			end
		end

		return self.respond_to!(poll)
	end


	def chosen_answer_for_question(question)
		self.chosen_answers.find_by(question_id: question.id)
	end

	def chosen_answer_for_question_before_end(question)
		self.chosen_answers.find_by(question_id: question.id)
	end


	# Method to try to convince other responders to a poll
	# it returns the hash of users convinced
	def try_to_convince_other_responders(poll)
		if poll.expert_user == self
			# Create a hash to remember who will have been convinced
			hash = Hash.new()
			poll.questions.each do |question|
				current_array = Array.new()
				hash.store(question.id, current_array)

				poll.participants.each do |participant|
					# Save current choice in history
					participant.chosen_answer_for_question(question).history_be_chosen_by!(participant)

					unless participant == self
						unless participant.chosen_answer_for_question(question) == self.chosen_answer_for_question(question)
							if random_number_is_under(self.influence)
								# The participant has changed his mind
								participant.chosen_answer_for_question(question).be_not_chosen_by!(participant)
								# He chooses the answer chosen by the expert
								self.chosen_answer_for_question(question).be_chosen_by!(participant)
								# Add the convinced user to the hash
								current_array.push(participant.first_name + " " + participant.name)
							end
						end
					end
				end
			end
		end
		# Returns hash
		hash
	end



	def User.new_remember_token
    	SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	private

	    def create_remember_token
	      self.remember_token = User.encrypt(User.new_remember_token)
	    end
end