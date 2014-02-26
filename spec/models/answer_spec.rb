require 'spec_helper'

describe Answer do
  before {
  	@answer = Answer.create(content: "Test answer")
  	@user = User.create(name: "Test", first_name: "Man", email: "test@man.com", influence: 56, password: "password", password_confirmation: "password")
  }
  subject {@answer}

  it { should respond_to(:content) }
  it { should respond_to(:question) }
  it { should respond_to(:responders) }
  it { should respond_to(:responders_history) }

  it { should be_valid }


  describe "when content is not present" do
  	before { @answer.update_attributes(content: "") }
  	it { should_not be_valid }
  end

  describe "return value of chosen_by? method" do
  	describe "when the user has chosen the answer" do
	  	before { @answer.be_chosen_by!(@user) }
	  	it { should be_chosen_by(@user) }
	end

	describe "when the user has not chosen the answer" do
	  	it { should_not be_chosen_by(@user) }
	end

	describe "when the user has chosen the answer first but changed his mind then" do
	  	before { 
	  		@answer.be_chosen_by!(@user)
	  		@answer.be_not_chosen_by!(@user) 
	  	}
	  	it { should_not be_chosen_by(@user) }
	end
  end

  describe "return value of history_chosen_by? method" do
  	describe "when the user had chosen the answer before validation" do
	  	before { @answer.history_be_chosen_by!(@user) }
	  	it { should be_history_chosen_by(@user) }
	end

	describe "when the user had not chosen the answer" do
	  	it { should_not be_history_chosen_by(@user) }
	end
  end
end
