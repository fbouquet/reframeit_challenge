require 'spec_helper'

describe User do
  before {
  	@user = User.new(name: "Example", first_name: "Reynald", email: "example@test.com", influence: 57, password: "greatpass", password_confirmation: "greatpass")
  }
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:first_name) }
  it { should respond_to(:email) }
  it { should respond_to(:influence) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }

  it { should be_valid }

  describe "when name is not present" do
  	before { @user.name = "" }
  	it { should_not be_valid }
  end

  describe "when first name is not present" do
  	before { @user.first_name = "" }
  	it { should_not be_valid }
  end

  describe "when email is not present" do
  	before { @user.email = "" }
  	it { should_not be_valid }
  end

  describe "when name is too long" do
  	before { @user.name = "a"*51 }
  	it { should_not be_valid }
  end

  describe "when first name is too long" do
  	before { @user.first_name = "a"*51 }
  	it { should_not be_valid }
  end

  describe "when email format is invalid" do
  	it "should be invalid" do
  		addresses = %w[user@foo,com user_at_foo.org user.foo.com hello@foo@orange.fr love@me+you.com]
  		addresses.each do |invalid_address|
  			@user.email = invalid_address
  			expect(@user).not_to be_valid
  		end
  	end
  end

  describe "when email format is valid" do
  	it "should be valid" do
  		addresses = %w[user@foo.com ComeOn@user.com hello@orange.fr me+you@yopmail.com]
  		addresses.each do |valid_address|
  			@user.email = valid_address
  			expect(@user).to be_valid
  		end
  	end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when password is not present" do
  	before do
  		@user = User.new(name: "Test", first_name: "Man", email: "test@man.com", influence: 56, password: "", password_confirmation: "")
  	end
  	it {should_not be_valid}
  end

  describe "when password doesn't match confirmation" do
  	before do
  		@user.password_confirmation = "badpass"
  	end
  	it {should_not be_valid}
  end

  describe "return value of authenticate method" do
  	before {@user.save}
  	let(:found_user) {User.find_by(email: @user.email)}

  	describe "with valid password" do
  		it {should == found_user.authenticate(@user.password)}
  	end

  	describe "with invalid password" do
  		let(:user_for_invalid_pass) {found_user.authenticate("invalidpass")}
  		it {should_not == user_for_invalid_pass}
  		specify {expect(user_for_invalid_pass).to be_false}
  	end

  	describe "with a password which is too short" do
  		before { @user.password = @user.password_confirmation = "a"*7 }
  		it {should_not be_valid}
  	end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end
