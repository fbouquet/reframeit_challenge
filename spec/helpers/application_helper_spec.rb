require 'spec_helper'


describe ApplicationHelper do
  describe "random function according to influence" do
  	describe "when influence is 100" do
  		it { random_number_is_under(100).should be_true }
  	end

  	describe "when influence is 0" do
  		it { random_number_is_under(0).should be_false }
  	end
  end
end