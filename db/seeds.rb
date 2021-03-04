# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Set up your user and team before running seeds

user = User.first
team = Team.first

alfonso = Customer.where(
  team: team,
  first_name: "alfonso",
  last_name: "ayala",
  email: "casamiaus2020@gmail.com",
  company: "Glide programer",
  country_code: "MX"
).first_or_create!

alfonso_thread_1 = MessageThread.where(
  team: team,
  customer: alfonso,
  subject: "Contact form submission"
).first_or_create!

Message.where(
  message_thread: alfonso_thread_1,
  sender: alfonso,
  body: "Hi, I'm from Mexico, it also works with Mexican banks.?",
  status: "received"
).first_or_create!
