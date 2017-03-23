# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(username: "admin", email: "test@test.de", password: "testadmin", role: "admin")
User.create(username: "planer", email: "planer@test.de", password: "testplaner", role: "planer")
User.create(username: "driver", email: "driver@test.de", password: "testdriver", role: "driver")
User.create(username: "user", email: "user@test.de", password: "testuser", role: "user")
