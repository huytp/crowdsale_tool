# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Stat.all.none?
  Stat.create(count: 1, last: 1)
end
if Setting.all.none?
  Setting.create(min_confirmation: 1, require_confirmation: true, max_btc: 10)
end