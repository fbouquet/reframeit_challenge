require 'spec_helper'

describe "PollPages" do
	subject { page }

  let(:poll) { FactoryGirl.create(:poll) }

  describe "index" do
    before(:each) do
      FactoryGirl.create(:poll)
      FactoryGirl.create(:poll, title: "Testify")
      poll = FactoryGirl.create(:poll, title: "Tasty test")

      sign_in FactoryGirl.create(:user, email: "non_expert_user@example.com") #poll.expert_user

      visit polls_path
    end

    it { should have_content('Polls list') }

    it "should list each poll" do
      Poll.all.each do |poll|
        expect(page).to have_content(poll.title)
      end
    end

    describe "pagination" do

      before(:all) { 10.times { FactoryGirl.create(:poll) } }
      after(:all)  { Poll.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each poll" do
        Poll.paginate(page: 1, per_page: 10).each do |poll|
          expect(page).to have_content(poll.title)
        end
      end
    end


    describe "delete links" do

      it { should_not have_link('Delete') }

      # describe "as an expert user" do
      #   let(:expert_user) { Poll.last.expert_user }
      #   before do
      #     sign_out
      #     sign_in expert_user
      #     visit polls_path
      #   end

      #   it { should have_link('Delete', href: poll_path(Poll.last)) }
      #   it "should be able to delete his poll" do
      #     expect do
      #       click_link('Delete', match: :first)
      #     end.to change(Poll, :count).by(-1)
      #   end
      # end

	  describe "as non-expert user" do
	    let(:non_expert_user) { FactoryGirl.create(:user, email: "non_expert@test.com") }

	    before do
	    	sign_in non_expert_user, no_capybara: true
	    end

	    describe "submitting a DELETE request to the Polls#destroy action" do
	      before { delete poll_path(poll) }
	      #specify { expect(response).to match("You must be the poll's expert user") }
	    end
	  end
    end
  end

  describe "poll page" do
    before do
      sign_in poll.expert_user
      visit poll_path(poll) 
    end

    it { should have_content(poll.title) }
    it { should have_link('Edit poll', href: edit_poll_path(poll)) }
    it { should have_link('Delete poll', href: poll_path(poll)) }
    it { should have_content("Poll expert: " + poll.expert_user.first_name + " " + poll.expert_user.name) }
    it { should have_link('Respond', href: respond_poll_path(poll)) }

    it "should list all questions and answers" do
      poll.questions.each do |question|
        page.should have_content(question.content)

        question.answers.each do |answer|
          page.should have_content(answer.content)
        end
      end
    end
  end

  describe "expert responds to poll" do
    before do
      sign_in poll.expert_user
      visit respond_poll_path(poll)
    end

    it { should have_content("Respond") }
    it { should have_content(poll.title) }

    let(:submit) { "Respond to this poll" }

    describe "with invalid information" do
      it "should not add a participant to the poll" do
        expect { click_button submit }.not_to change(poll.participants, :count)
      end
    end

    describe "with valid information" do
      before do
        poll.questions.each do |question|
          choose(question.answers.first.content)
        end
      end

      it "should add a participant to the poll" do
        expect { click_button submit }.to change(poll.participants, :count).by(1)
      end

      describe "after saving the response" do
        before { click_button submit }

        it { should have_content("Successfully responded") }
        it { should_not have_link('Respond', href: respond_poll_path(poll)) }
        it { should have_link('End', href: end_poll_path(poll)) }

        describe "expert ends poll" do
          before do
            visit end_poll_path(poll)
          end

          it { should have_content "Convinced users for each question" }
          it { should_not have_link('Respond', href: respond_poll_path(poll)) }
          it { should_not have_link('End', href: end_poll_path(poll)) }
          it { should_not have_link('Edit', href: edit_poll_path(poll)) }
          it { should have_link('Final results', href: "#current_results") }
          it { should have_link('Results before validation', href: "#history_results") }
        end

        describe "poll expires when any user views it" do
          let(:user) { FactoryGirl.create(:user) }

          before do
            poll.update_attributes(ends_at: 1.minute.ago)
            sign_out
            sign_in user
            visit poll_path(poll)
          end

          it { should_not have_link('Respond', href: respond_poll_path(poll)) }
          it { should_not have_link('End', href: end_poll_path(poll)) }
          it { should_not have_link('Edit', href: edit_poll_path(poll)) }
          it { should have_link('Final results', href: "#current_results") }
          it { should have_link('Results before validation', href: "#history_results") }
        end
      end
    end
  end


  describe "poll doesn't expire anyway if the expert did not respond to it" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      poll.update_attributes(ends_at: 1.minute.ago)
      sign_in user
      visit poll_path(poll)
    end

    it { should_not have_link('Final results', href: "#current_results") }
    it { should_not have_link('Results before validation', href: "#history_results") }
  end


  describe "edit page", js: true do
    let(:poll) { FactoryGirl.create(:poll) }
    before do
      Capybara.current_driver = :selenium
      sign_in poll.expert_user
      visit edit_poll_path(poll)
    end

    after do
      Capybara.use_default_driver
    end

    it { should have_content("Edit") }

    let(:submit) { "Edit poll" }

    describe "add a question" do
      before do 
        find_link("Add question").click
      end

      it "should add a question to the poll" do
        expect { 
          within all('.question_field').last do
            fill_in 'Question', :with => Faker::Lorem.sentence
          end
          click_button submit }.to change(poll.questions, :count).by(1)
      end
    end

    describe "add an answer" do
      before do
        within all('.answer_fields').last do
          find_link("Add answer").click
        end
      end

      it "should add an answer to the poll" do
        expect {
          within all('.answer_field').last do
            fill_in 'Answer', :with => Faker::Lorem.sentence
          end
          click_button submit
          }.to change(poll.questions.last.answers, :count).by(1)
      end
    end
  end


  describe "new poll", js: true do
    let(:user) { FactoryGirl.create(:user) }
    before do
      Capybara.current_driver = :selenium
      sign_in user
      visit new_poll_path
    end

    after do
      Capybara.use_default_driver
    end

    it { should have_content("Create") }

    let(:submit) { "Create poll" }

    describe "add two questions and two answers for each" do
      before do
        fill_in 'Title', :with => Faker::Lorem.sentence

        2.times do |i|
          find_link("Add question").click
          within all('.question_field')[i] do
            fill_in 'Question', :with => Faker::Lorem.sentence
          end

          within all('.answer_fields')[i] do
            2.times { find_link("Add answer").click }
          end
        end

        4.times do |i|
          within all('.answer_field')[i] do
            fill_in 'Answer', :with => Faker::Lorem.sentence
          end
        end
      end

      it "should create the poll" do
        expect { click_button submit }.to change(Poll, :count).by(1)
      end

      it "should create the questions" do
        expect { click_button submit }.to change(Question, :count).by(2)
      end

      it "should create the answers" do
        expect { click_button submit }.to change(Answer, :count).by(4)
      end

      describe "the new poll" do
        before { poll = Poll.all.last }

        it "should be linked to the new questions" do
          poll.questions.count.should == 2
        end

        it "should have each question linked to their answers" do
          poll.questions.each do |question|
            question.answers.count.should == 2
          end
        end
      end
    end
  end
end
