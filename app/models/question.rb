class Question < ActiveRecord::Base
	belongs_to :poll
	has_many :answers, dependent: :destroy
	has_one :correct_answer, class_name: "Answer"

	accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true

	validates :content, presence: true
end
