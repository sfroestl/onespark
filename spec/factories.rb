FactoryGirl.define do
  factory :user do
    name     "Sebastian Froestl"
    email    "sebastian@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end