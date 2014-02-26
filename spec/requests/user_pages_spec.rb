require 'spec_helper'

describe "UserPages" do
  before { User.delete_all }

  subject { page }


  describe "index" do
    before(:each) do
      sign_in FactoryGirl.create(:user, email: "test@example.com")
      FactoryGirl.create(:user, first_name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, first_name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_content('Users list') }

    it "should list each user" do
      User.all.each do |user|
        expect(page).to have_content(user.first_name + " " + user.name)
      end
    end

    describe "pagination" do

      before(:all) do 
        User.delete_all
        11.times { FactoryGirl.create(:user) }
      end
      after(:all)  { User.delete_all }

      it "should list each user" do
        User.paginate(page: 1, per_page: 10).each do |user|
          expect(page).to have_content(user.first_name + " " + user.name)
        end
      end
    end


    describe "delete links" do
      it { should have_link('Delete', href: user_path(User.first)) }
      it "should be able to delete a user" do
        expect do
          click_link('Delete', match: :first)
        end.to change(User, :count).by(-1)
      end
    end
  end


  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.first_name) }
    it { should have_content(user.name) }
    it { should have_content("Edit profile") }
    it { should have_content("Delete user") }
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
      	fill_in "First name",   with: "User"
        fill_in "Name",         with: "Example"
        fill_in "Email",        with: "user@example.com"
        fill_in "Influence",    with: 57
        fill_in "Password",     with: "testpass"
        fill_in "Confirmation", with: "testpass"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_link('Parameters') }
        it { should have_selector('div.alert.alert-info', text: 'Welcome') }

        describe "followed by signout" do
  	      before { click_link 'Sign out' }
  	      it { should have_link('Sign in') }
	      end
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Change profile parameters") }
    end

    describe "with invalid information" do
      before { click_button "Change" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_influence)  { 88 }
      before do
        fill_in "Influence",        with: new_influence
        fill_in "Password",         with: user.password
        fill_in "Confirmation", with: user.password
        click_button "Change"
      end

      it { should have_selector('div.alert.alert-info') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.influence).to  eq new_influence }
    end
  end
end
