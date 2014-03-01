require 'spec_helper'

describe Poll do
  before {
  	@user = User.create(name: "Test", first_name: "Man", email: "test@man.com", influence: 56, password: "password", password_confirmation: "password")
  	@poll = Poll.create(title: "Test poll", expert_user: @user, ends_at: 1.day.from_now)
  }
  subject {@poll}

  it { should respond_to(:title) }
  it { should respond_to(:questions) }
  it { should respond_to(:expert_user) }
  it { should respond_to(:participants) }
  it { should respond_to(:ends_at) }

  it { should be_valid }


  describe "when title is not present" do
  	before { @poll.title = "" }
  	it { should_not be_valid }
  end

  describe "when expert user is not present" do
  	before { @poll.expert_user = nil }
  	it { should_not be_valid }
  end

  describe "when ends_at is not present" do
    before { @poll.ends_at = nil }
    it { should_not be_valid }
  end

  describe "function finished? should return" do
  	describe "true if the poll is finished" do
  		before { @poll.finished! }
  		it { should be_finished }
  	end

    describe "true if ends_at is less than or equal to now date and expert has responded" do
      before do 
          @poll.ends_at = DateTime.now
          # Lets consider that the expert has already responded
          @poll.expert_user.respond_to!(@poll)
      end
      it { should be_finished }
    end

    describe "false if ends_at is less than or equal to now date but expert has not responded yet" do
      before do 
          @poll.ends_at = DateTime.now
      end
      it { should_not be_finished }
    end
    
    describe "false if ends_at is greater than now date" do
      before do
          @poll.ends_at = 1.hours.from_now
      end
      it { should_not be_finished }
    end

  	describe "false else" do
  		it { should_not be_finished }
  	end
  end
end
