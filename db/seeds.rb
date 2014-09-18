# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# CSV Import
# require 'csv'
# CSV.foreach(Rails.root.join("db/seeds_data/movies.csv"), headers: true) do |row|
#   Movie.find_or_create_by(title: row[0], release_year: row[1], price: row[2], description: row[3], imdb_id: row[4], poster_url: row[5])
# end

20.times do
  stats = { first_name: Faker::Name.first_name, last_name: Faker::Name.last_name }
  Author.create(stats)
end

tags = []
30.times do
  tags << Faker::App.name
end
tags.uniq!

200.times do
  stats = { author: Author.all.sample, title: Faker::Hacker.say_something_smart, content: Faker::Lorem.paragraph(5), approved: true, list_of_tags: tags.sample(rand(2..4)).join(", ") }
  Book.create(stats)
end

500.times do
  stats = { title: Faker::Hacker.say_something_smart, book: Book.all.sample, rating: rand(1..5), approved: true }
  Review.create(stats)
end
