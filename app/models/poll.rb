class Poll < ActiveRecord::Base
	belongs_to :expert_user, class_name: "User"
	has_many :questions, dependent: :destroy
	
	#has_and_belongs_to_many :participants, class_name: "User", foreign_key: "user_id", association_foreign_key: "poll_id"
	has_many :user_poll_relationships
	has_many :participants, through: :user_poll_relationships, source: :user

	accepts_nested_attributes_for :questions, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true

	validates :title, presence: true
	validates :expert_user, presence: true

	def finished?
		self.finished == 1
	end

	def finished!
		self.update_attributes(finished: 1)
	end

	private
		def set_defaults
			self.finished = 0
		end
end
