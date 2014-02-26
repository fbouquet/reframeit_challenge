require 'spec_helper'

describe "StaticPages" do
  subject { page }

  describe "home page" do
    before { visit root_url }

    it { should have_content("Welcome") }
    it { should have_content("Sign in") }

    describe "when logged in" do
    	let(:user) { FactoryGirl.create(:user) }
    	before { sign_in user }

    	it { should have_content(user.first_name) }
    end
  end
end
