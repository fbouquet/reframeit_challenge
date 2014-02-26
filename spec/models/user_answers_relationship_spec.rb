require 'spec_helper'

describe UserAnswersRelationship do
  before {
  	@relationship = UserAnswersRelationship.new(user_id: 2, answer_id: 10)
  }
  subject { @relationship }

  it { should respond_to(:user_id) }
  it { should respond_to(:answer_id) }

  it { should be_valid }

  describe "when user id is not present" do
  	before { @relationship.user_id = nil }
  	it { should_not be_valid }
  end

  describe "when answer id is not present" do
  	before { @relationship.answer_id = nil }
  	it { should_not be_valid }
  end
end
