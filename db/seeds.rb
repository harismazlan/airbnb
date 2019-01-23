# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = {}
user['password'] = 'asdf'


ActiveRecord::Base.transaction do
  200.times do 
    user['first_name'] = Faker::Name.first_name 
    user['last_name'] = Faker::Name.last_name
    user['email'] = Faker::Internet.email
    
    User.create(user)

  end
end 

# Seed Listings
listing = {}
uids = []
User.all.each { |u| uids << u.id }

ActiveRecord::Base.transaction do
  100.times do 
    listing['name'] = Faker::App.name
    listing['property_type'] = ["House", "Entire Floor", "Condominium", "Villa", "Townhouse", "Castle", "Treehouse", "Igloo", "Yurt", "Cave", "Chalet", "Hut", "Tent", "Other"].sample
    listing['number_of_beds'] = rand(1..6)
    listing['country'] = Faker::Address.country
    listing['state'] = Faker::Address.state
    listing['address'] = Faker::Address.street_address
    listing['price'] = rand(80..500)
    listing['description'] = Faker::Hipster.sentence
    listing['user_id'] = uids.sample
    listing['available_from'] = Faker::Date.between(Date.today, 30.days.from_now)
    listing['available_to'] = Faker::Date.between(listing['available_from'] + 1.day, listing['available_from'] + 100.days)
         
    Listing.create(listing)
  end
end