class Question < ActiveRecord::Base
	belongs_to :poll
	has_many :answers, dependent: :destroy
	has_one :correct_answer, class_name: "Answer"

	validates :content, presence: true
end
