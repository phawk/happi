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

# Message.delete_all

#
# alfonso
#

alfonso = Customer.where(
  team: team,
  email: "casamiaus2020@gmail.com",
).first_or_initialize

alfonso.update!(
  first_name: "Alfonso",
  last_name: "Ayala",
  company: "Glide programer",
  country_code: "MX"
)

alfonso_thread_1 = MessageThread.where(
  team: team,
  customer: alfonso,
).first_or_initialize

alfonso_thread_1.update!(
  subject: "Contact form submission"
)

Message.create!(
  message_thread: alfonso_thread_1,
  sender: alfonso,
  content: "Hi, I'm from Mexico, it also works with Mexican banks.?",
  status: "received"
)

Message.create!(
  message_thread: alfonso_thread_1,
  sender: user,
  content: "Hi Alfonso,<br /><br />We use Stripe to support card payments, I think they are still in beta in Mexico,
    if you have a Stripe account, you shouldn’t have any problems connecting it to Payhere.<br /><br />Best,<br />Pete",
  status: "sent"
)

#
#
#

josh = Customer.where(
  team: team,
  email: "joshuat@me.com",
).first_or_initialize

josh.update!(
  first_name: "Josh",
  last_name: "Toole",
  company: "House Ninja",
  country_code: "US"
)

josh_thread_1 = MessageThread.where(
  team: team,
  customer: josh,
).first_or_initialize

josh_thread_1.update!(
  subject: "Add billing address to payment form"
)

Message.create!(
  message_thread: josh_thread_1,
  sender: josh,
  content: "Hi, I'm wondering if there's a way to add billing address fields to a payment form? Thanks!",
  status: "received"
)
