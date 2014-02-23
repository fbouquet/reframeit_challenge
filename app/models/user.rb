class User < ActiveRecord::Base
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

	# Relationship with polls into which the user takes part
	has_many :user_poll_relationships
	has_many :answered_polls, through: :user_poll_relationships, source: :poll
	#has_and_belongs_to_many :polls

	def responded_to?(poll)
		user_poll_relationships.find_by(poll_id: poll.id)
	end

	def respond_to!(poll)
		# We just want to create the association. Replace has_and_many by has_many through
		#ActiveRecord::Base.connection.execute("INSERT INTO polls_users(user_id, poll_id) VALUES (" + self.id.to_s + ", " + poll.id.to_s + ")")
		user_poll_relationships.create!(poll_id: poll.id)
	end

	def unrespond_to!(poll)
		#ActiveRecord::Base.connection.execute("DELETE FROM polls_users WHERE user_id=" + self.id.to_s + " AND poll_id=" + poll.id.to_s)
		user_poll_relationships.find_by(poll_id: poll.id).destroy
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