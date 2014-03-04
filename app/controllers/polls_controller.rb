class PollsController < ApplicationController
	include PollsHelper

	before_action :signed_in_user, only: [:new, :create, :edit, :update, :destroy, :mypolls, :respond, :respond_save]
	before_action :correct_user, only: [:edit, :update, :destroy]
	before_action :poll_not_finished, only: [:edit, :update, :respond, :respond_save, :end_poll]
	before_action :not_responded_yet, only: [:respond, :respond_save]
	before_action :has_answered_every_question, only: [:respond_save]
	before_action :current_user_is_expert, only: [:end_poll]
	before_action :expert_user_has_responded, only: [:end_poll]

	def index
		@polls = Poll.recent.paginate(page: params[:page])
		@title = "Polls list"
	end

	def mypolls
		if @polls = current_user.polls.recent.paginate(page: params[:page])
			@title = "My polls"
			@only_mypolls_shown = true
			render "index"
		else
			redirect_to polls_path, notice: "You are not the expert user for any poll for the moment, but you can create one."
		end
	end

	def show
		@poll = Poll.find(params[:id])
		@expert_user = @poll.expert_user
		@participants = @poll.participants
		@questions = @poll.questions
	end

	def new
		@poll = Poll.new()
	end

	def create
		@poll = current_user.polls.build(poll_params)
		@poll.ends_at = parse_datetime_select(poll_params)
		if @poll.save
			redirect_to @poll, notice: "Successfully created poll."
		else
			render "new"
		end
	end

	def edit
		@poll = Poll.find(params[:id])
	end

	def update
		@poll = Poll.find(params[:id])
		@poll.ends_at = parse_datetime_select(poll_params)

		if @poll.update_attributes(poll_params)
			redirect_to @poll, notice: "Successfully updated poll."
		else
			render "edit"
		end
	end

	def destroy
		@poll = Poll.find(params[:id])
		if @poll.destroy
			redirect_to polls_path, notice: "Successfully deleted poll."
		else
			redirect_to @poll
		end
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
		if current_user.save_answers_and_respond_to!(@poll, params)
			redirect_to @poll, notice: "Successfully responded to this poll."
		else
			redirect_to respond_poll_path(@poll), notice: "Something went wrong: please try again."
		end
	end

	# Controller to end a poll manually
	def end_poll
		@poll = Poll.find(params[:id])

		convinced_users_hash = @poll.end_poll
		redirect_to @poll, notice: convinced_users_hash_to_s(convinced_users_hash)
	end


	private
		def poll_params
			params.require(:poll).permit(:title, :ends_at, questions_attributes: [:content, :id, :_destroy, answers_attributes: [:content, :id, :_destroy]])
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
				return
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
