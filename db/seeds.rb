# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Author.create(first_name: "Christos", last_name: "Maroudas")

400.times do
  stats = { author: Author.first, title: Faker::Lorem.sentence(3), content: Faker::Lorem.paragraph(5) }
  Book.create(stats)
end