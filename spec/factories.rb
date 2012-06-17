FactoryGirl.define do

  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
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
  
  factory :milestone do
    title   "Milestone 1"
    desc    "example milestone description here"
    due_date 3.days.from_now
    project
    user
  end
end