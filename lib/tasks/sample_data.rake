namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(username: "exampleuname",
                       name: "Example User",
                       email: "example@railstutorial.org",
                       password: "foobar",
                       password_confirmation: "foobar",
                       confirmed_at: Time.now)
  admin.toggle!(:admin)
  99.times do |n|
    username = "#{Faker::Internet.user_name}_#{n}"
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    confirmed_at = Time.now
    User.create!(username: username,
                 name: name,
                 email: email,
                 password: password,
                 password_confirmation: password,
                 confirmed_at: confirmed_at)
  end
end

def make_microposts
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each {|user| user.microposts.create!(content: content)}
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  followed_users.each{|followed| user.follow!(followed)}
  followers.each{|follower| follower.follow!(user)}
end
