class Poll < ActiveRecord::Base
	belongs_to :expert_user, class_name: "User"
	has_many :questions, dependent: :destroy
	
	has_many :user_poll_relationships
	has_many :participants, through: :user_poll_relationships, source: :user

	accepts_nested_attributes_for :questions, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true

	after_find { finished? }

	validates :title, presence: true
	validates :expert_user, presence: true
	validates :ends_at, presence: true

	def finished?
		if !self.ends_at.future? and expert_has_responded? and finished != 1
			self.end_poll
		end
		self.finished == 1
	end

	def finished!
		self.update_attributes(finished: 1)
		# Update ends_at if necessary
		if ends_at.future?
			self.update_attributes(ends_at: DateTime.now)
		end
	end

	def not_finished!
		self.update_attributes(finished: 0)
	end

	def expert_has_responded?
		self.expert_user.responded_to?(self)
	end

	# Manually ending the poll
	def end_poll
		# The expert user tries to convince the others
		self.finished!
		convinced_users_hash = self.expert_user.try_to_convince_other_responders(self)
	end

	private
		def set_defaults
			self.finished = 0
		end
end
