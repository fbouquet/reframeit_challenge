#require 'faker'

FactoryGirl.define do
  factory :user do
    first_name "Mister"
    sequence(:name)  { |n| "Smith_#{n}" }
    #sequence(:email) { |n| "smith_#{n}@example.com"}
    email { Faker::Internet.email }
    influence 57
    password "mybigpass"
    password_confirmation "mybigpass"
  end

  factory :answer do
    content { Faker::Lorem.sentence }
  end

  factory :question do
    content { Faker::Lorem.sentence }

    answers { 
      answers_list = []
      2.times { answers_list.push FactoryGirl.create(:answer) }
      answers_list 
    }
  end

  factory :poll do
    sequence(:title)  { |n| "Poll #{n}" }
    expert_user { FactoryGirl.create(:user) }
    ends_at { 1.days.from_now }

    questions { 
      questions_list = []
      2.times { questions_list.push FactoryGirl.create(:question) }
      questions_list
    }
  end
end