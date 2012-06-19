namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    [User, Profile, Project, Milestone].each(&:delete_all)
    
    Project.populate 15 do |project|
      project.title = Populator.words(1..2).titleize
      project.desc = Populator.sentences(1..6)
      project.due_date = 1.week.from_now..1.year.from_now
      
      Milestone.populate 3..15 do |milestone|
        milestone.project_id = project.id
        milestone.title = Populator.words(1..5).titleize
        milestone.goal = Populator.words(4..10)
        milestone.desc = Populator.sentences(2..10)
        milestone.due_date = 1.week.from_now..1.year.from_now
      end
    end
    
    User.create!(username: "bob",
                 email: "bob@onespark.de",
                 password: "asdasd",
                 password_confirmation: "asdasd")
    User.create!(username: "sfroestl",
                 email: "sebastian@froestl.com",
                 password: "asdasd",
                 password_confirmation: "asdasd")

    User.populate 30 do |user|
      user.username  = Faker::Name.first_name
      user.email     = Faker::Internet.email
      user.password_digest  = "pass"
      Profile.populate 1 do |profile|
        profile.user_id   = user.id
        profile.city      = Faker::Address.city
        profile.forename  = Faker::Name.first_name
        profile.surname   = Faker::Name.last_name
        profile.about     = Populator.sentences(1..5)
      end
    end
  end
end