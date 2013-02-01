# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin_role = Role.create([{name: "admin"}])
user_role = Role.create([{name: "golfer"}])

admin = User.new(
  :email => "the-team@cloudspace.com",
  :password => "cloudspace",
  :roles => [admin_role]
)
admin.save validate: false