require 'spec_helper'

describe Poll do
  before {
  	@user = User.create(name: "Test", first_name: "Man", email: "test@man.com", influence: 56, password: "password", password_confirmation: "password")
  	@poll = Poll.new(title: "Test poll", expert_user: @user)
  }
  subject {@poll}

  it { should respond_to(:title) }
  it { should respond_to(:questions) }
  it { should respond_to(:expert_user) }
  it { should respond_to(:participants) }

  it { should be_valid }


  describe "when title is not present" do
  	before { @poll.title = "" }
  	it { should_not be_valid }
  end

  describe "when expert user is not present" do
  	before { @poll.expert_user = nil }
  	it { should_not be_valid }
  end

  describe "function finished? should return" do
  	describe "true if the poll is finished" do
  		before { @poll.finished! }
  		it { should be_finished }
  	end

  	describe "false else" do
  		it { should_not be_finished }
  	end
  end
end
