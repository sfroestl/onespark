FactoryGirl.define do
  factory :user do
    name     "Sebastian Froestl"
    email    "sebastian@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
  
  factory :activity do
    title   "Example Activity"
    description "This is the description of a sample activity"
    user
    due_date 2.days.from_now
  end
end