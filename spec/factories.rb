FactoryGirl.define do
  factory :user do
    name     "Sebastian Froestl"
    email    "sebastian@example.com"
    password "foobar"
    password_confirmation "foobar"
  end

  
  factory :project do
    title   "Example project"
    desc    "example project's description here"
    user
    due_date 3.days.from_now
  end
  
  factory :milestone do
    title   "Milestone 1"
    desc    "example milestone description here"
    due_date 3.days.from_now
    project
    user
  end
end