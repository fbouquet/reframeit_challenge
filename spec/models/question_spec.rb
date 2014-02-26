require 'spec_helper'

describe Question do
  before {
  	@question = Question.new(content: "Test question")
  }
  subject {@question}

  it { should respond_to(:content) }
  it { should respond_to(:answers) }
  it { should respond_to(:correct_answer) }

  it { should be_valid }


  describe "when content is not present" do
  	before { @question.content = "" }
  	it { should_not be_valid }
  end
end
