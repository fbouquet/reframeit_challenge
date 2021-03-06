require 'spec_helper'

describe UserPollRelationship do
  before {
  	@relationship = UserPollRelationship.new(user_id: 2, poll_id: 10)
  }
  subject { @relationship }

  it { should respond_to(:user_id) }
  it { should respond_to(:poll_id) }

  it { should be_valid }

  describe "when user id is not present" do
  	before { @relationship.user_id = nil }
  	it { should_not be_valid }
  end

  describe "when answer id is not present" do
  	before { @relationship.poll_id = nil }
  	it { should_not be_valid }
  end
end
