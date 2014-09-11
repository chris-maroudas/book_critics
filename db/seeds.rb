# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

100.times do
  stats = { first_name: Faker::Name.first_name, last_name: Faker::Name.last_name }
  Author.create(stats)
end

400.times do
  stats = { author: Author.all.sample, title: Faker::Hacker.say_something_smart, content: Faker::Lorem.paragraph(5) }
  Book.create(stats)
end