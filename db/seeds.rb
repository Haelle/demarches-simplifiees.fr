# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

#
# Create an initial user who can use all roles
#

default_user = "test@exemple.fr"
default_password = "this is a very complicated password !"

puts "Create test user '#{default_user}'"
# Make it idempotent when user already exist, return
return if SuperAdmin.find_by_email(default_user)

SuperAdmin.create!(email: default_user, password: default_password)
user = User.create!(
  email: default_user,
  password: default_password,
  confirmed_at: Time.zone.now,
  email_verified_at: Time.zone.now
)
user.create_instructeur!
user.create_administrateur!
