class PollsController < ApplicationController
	before_action :signed_in_user, only: [:new, :create, :edit, :update, :destroy, :mypolls, :respond, :respond_save]
	before_action :correct_user, only: [:edit, :update, :destroy]
	before_action :poll_not_finished, only: [:edit, :update, :respond, :respond_save]
	before_action :not_responded_yet, only: [:respond, :respond_save]
	before_action :has_answered_every_question, only: [:respond_save]
	before_action :current_user_is_expert, only: [:end_poll]
	before_action :expert_user_has_responded, only: [:end_poll]

	def index
		@polls = Poll.order("finished").paginate(page: params[:page], per_page: 10)
		@title = "Polls list"
	end

	def mypolls
		if @polls = Poll.where(expert_user: current_user).paginate(page: params[:page], per_page: 10, order: "finished")
			@title = "My polls"
			@only_mypolls_shown = true
			render "index"
		else
			flash[:info] = "You are not the expert user for any poll for the moment, but you can create one."
			redirect_to polls_path
		end
	end

	def show
		@poll = Poll.find(params[:id])
		@expert_user = @poll.expert_user
		@participants = @poll.participants
		@questions = @poll.questions
	end

	# Controller to display the form to respond to a poll
	def respond
		@poll = Poll.find(params[:id])
		@expert_user = @poll.expert_user
		@participants = @poll.participants
		@questions = @poll.questions
	end

	# Controller to save response to a poll 
	def respond_save
		@poll = Poll.find(params[:id])
		@questions = @poll.questions

		logger.debug params

		@questions.each do |question|
			answer_id = params["question_" + question.id.to_s + "_answer"]

			unless Answer.find(answer_id).be_chosen_by!(current_user)
				flash[:error] = "Something went wrong while saving your answer to a question. Please try again."
				redirect_to respond_poll_path(@poll)
			end
		end

		if current_user.respond_to!(@poll)
			flash[:success] = "Successfully responded to this poll."
			redirect_to @poll
		else
			flash[:error] = "Something went wrong while saving your response. Please try again."
			redirect_to respond_poll_path(@poll)
		end
	end

	# Controller to end a poll
	def end_poll
		@poll = Poll.find(params[:id])
		
		# The expert user tries to convince the others
		convinced_users_hash = @poll.expert_user.try_to_convince_other_responders(@poll)
		flash[:info] = convinced_users_hash_to_s(convinced_users_hash)

		@poll.finished!

		redirect_to @poll
	end

	def new
		@poll = Poll.new()
		# question = @poll.questions.build
		# 3.times do
		# 	question.answers.build
		# end
	end

	def create
		@poll = current_user.polls.build(poll_params)
		if @poll.save
			flash[:success] = "Successfully created poll."
			redirect_to @poll
		else
			render "new"
		end
	end

	def edit
		@poll = Poll.find(params[:id])
	end

	def update
		@poll = Poll.find(params[:id])

		logger.info params[:poll]
		logger.info poll_params

		if @poll.update_attributes(poll_params)
			flash[:success] = "Successfully updated poll."
			redirect_to @poll
		else
			render "edit"
		end
	end

	def destroy
		@poll = Poll.find(params[:id])
		if @poll.destroy
			flash[:success] = "Successfully deleted poll."
			redirect_to polls_path
		else
			redirect_to @poll
		end
	end

	private
		def poll_params
			params.require(:poll).permit(:title, questions_attributes: [:content, :id, :_destroy, answers_attributes: [:content, :id, :_destroy]])
		end

		# Before actions

		def correct_user
			@poll = Poll.find(params[:id])
			unless current_user == @poll.expert_user
				redirect_to polls_path, notice: "You must be the poll's expert user to edit or destroy this poll."
			end
		end

		def poll_not_finished
			@poll = Poll.find(params[:id])
			if @poll.finished?
				flash[:info] = "This poll has been closed: you can't respond to it nor edit it anymore."
				redirect_to @poll
			end
		end

		def not_responded_yet
			@poll = Poll.find(params[:id])
			if @poll.participants.exists?(current_user)
				flash[:info] = "You have already responded to this poll."
				redirect_to @poll
			end
		end

		def has_answered_every_question
			@poll = Poll.find(params[:id])
			@poll.questions.each do |question|
				if params["question_" + question.id.to_s + "_answer"].blank?
					flash[:info] = "Please answer every question."
					redirect_to respond_poll_path(@poll) and return
				end
			end
		end

		def current_user_is_expert
			@poll = Poll.find(params[:id])
			unless current_user == @poll.expert_user
				flash[:info] = "You are not the expert user for this poll: you can't end it."
				redirect_to respond_poll_path(@poll)
			end
		end

		def expert_user_has_responded
			@poll = Poll.find(params[:id])
			unless @poll.expert_user.responded_to?(@poll)
				flash[:info] = "You have to respond to the poll before ending it."
				redirect_to respond_poll_path(@poll)
			end
		end
end
