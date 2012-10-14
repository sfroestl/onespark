
FactoryGirl.define do

  factory :user do
    sequence(:username)  { |n| "person#{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
  end

  factory :creator do
    sequence(:username)  { |n| "person#{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
  end

  factory :project do
    title   "Example project"
    desc    "example project's description here"
    due_date 3.days.from_now
    user
  end


  factory :tasklist do
    title   "Milestone 1"
    desc    "example milestone description here"
    due_date 3.days.from_now
    project
    creator
  end


  factory :profile do
    sequence(:forename) { |n| "Vorname #{n}" }
    sequence(:surname) { |n| "Namchname #{n}" }
    user
  end
end