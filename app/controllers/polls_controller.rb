class PollsController < ApplicationController
	before_action :signed_in_user, only: [:edit, :update, :destroy]

	def new
		@poll = Poll.new()
	end

	def index
		@polls = Poll.paginate(page: params[:page], per_page: 10)
	end

	def show
		@poll = Poll.find(params[:id])
		@expert_user = @poll.expert_user
		@participants = @poll.participants
		@questions = @poll.questions
	end
end
