# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(first_name: "Florent", name: "B.", email: "flo@example.com", influence: 85, password: "testtest", password_confirmation: "testtest")
User.create(first_name: "Second", name: "User", email: "second@user.com", influence: 50, password: "testtest", password_confirmation: "testtest")
User.create(first_name: "Third", name: "User", email: "third@user.com", influence: 35, password: "testtest", password_confirmation: "testtest")
User.create(first_name: "Fourth", name: "User", email: "fourth@user.com", influence: 64, password: "testtest", password_confirmation: "testtest")
User.create(first_name: "Fifth", name: "User", email: "fifth@user.com", influence: 13, password: "testtest", password_confirmation: "testtest")
User.create(first_name: "Sixth", name: "User", email: "sixth@user.com", influence: 93, password: "testtest", password_confirmation: "testtest")
User.create(first_name: "Seventh", name: "User", email: "seventh@user.com", influence: 47, password: "testtest", password_confirmation: "testtest")