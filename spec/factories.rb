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
    due_date 3.days.from_now
  end
  
  factory :ticket do
    title   "Example Ticket"
    desc    "example ticket here"
    due_date 3.days.from_now
    project
  end
end