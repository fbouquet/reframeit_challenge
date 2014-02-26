require 'spec_helper'

describe "AuthentificationPages" do
	subject { page }

	describe "signin page" do
		before { visit signin_path }

	    it { should have_content('Sign in') }
	end

	describe "signin" do
	    before { visit signin_path }

	    describe "with invalid information" do
	      before { click_button "Sign in" }

	      it { should have_content("Please try again") }

	      describe "after visiting another page" do
	        before { click_link "Deliberative polls" }
	        it { should_not have_selector('div.alert.alert-error') }
	      end
	    end

	    describe "with valid information" do
	      let(:user) { FactoryGirl.create(:user) }
	      before { sign_in user }

	      it { should have_link('Profile',     href: user_path(user)) }
	      it { should have_link('Users',       href: users_path) }
	      it { should have_link('Sign out',    href: signout_path) }
	      it { should have_link('Parameters',     href: edit_user_path(user)) }
	      it { should_not have_link('Sign in', href: signin_path) }
	    end
	end


	describe "authorization" do
	    describe "for non-signed-in users" do
	      let(:user) { FactoryGirl.create(:user) }

	      describe "when attempting to visit a protected page" do
	        before do
	          visit edit_user_path(user)
	          fill_in "Email",    with: user.email
	          fill_in "Password", with: user.password
	          click_button "Sign in"
	        end

	        describe "after signing in" do
	          it "should render the desired protected page" do
	            expect(page).to have_content('Change profile parameters')
	          end
	        end
	      end

	      describe "in the Users controller" do

	        describe "visiting the edit page" do
	          before { visit edit_user_path(user) }
	          it { should have_content('Please sign in') }
	        end

	        describe "submitting to the update action" do
	          before { patch user_path(user) }
	          specify { expect(response).to redirect_to(signin_path) }
	        end

	        describe "visiting the user index" do
	          before { visit users_path }
	          it { should have_content('Please sign in') }
	        end
	      end
	    end
  	end
end
