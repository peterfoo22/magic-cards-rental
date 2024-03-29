require 'json'
require 'open-uri'
require 'faker'

# Clear the database from every instances before seeding again
Booking.destroy_all
Card.destroy_all
User.destroy_all


# Generating a card, with its associated user(buyer) and booking with its associated user(buyer) and card(whose user_id belongs to the seller). Generating x instances.
puts "Seeding 8 buyers (user), 8 sellers (user), 8 cards and 8 bookings, adding Reviews..."
puts "------------------"

dev = User.create(
  email: "dev@email.com",
  password: "password",
  first_name:  Faker::Name.first_name,
  last_name: Faker::Name.last_name,
)

id = rand(1..4880)
url = "https://api.magicthegathering.io/v1/cards/#{id}"
card_serialized = open(url).read
card = JSON.parse(card_serialized)

new_card = Card.new(
  name: card["card"]["name"],
  color: card["card"]["colors"][0],
  card_type: card["card"]["type"],
  cmc: card["card"]["cmc"].to_s,
  power: card["card"]["power"] ,
  toughness: card["card"]["toughness"],
  img_url: card["card"]["imageUrl"],
  price_per_week: p = rand(5..200),
  user: dev
)
new_card.save
p "created dev card"

id = rand(1..4880)
url = "https://api.magicthegathering.io/v1/cards/#{id}"
card_serialized = open(url).read
card = JSON.parse(card_serialized)

new_card = Card.new(
  name: card["card"]["name"],
  color: card["card"]["colors"][0],
  card_type: card["card"]["type"],
  cmc: card["card"]["cmc"].to_s,
  power: card["card"]["power"] ,
  toughness: card["card"]["toughness"],
  img_url: card["card"]["imageUrl"],
  price_per_week: p = rand(5..200),
  user: dev
)
new_card.save
p "created dev card"


for i in (1..8) do
  id = rand(1..4880)
  url = "https://api.magicthegathering.io/v1/cards/#{id}"
  card_serialized = open(url).read
  card = JSON.parse(card_serialized)

  new_user_buyer = User.new(
    email:    Faker::Internet.email,
    password: "password",
    first_name:  Faker::Name.first_name,
    last_name: Faker::Name.last_name,
  )
  new_user_buyer.save
  if new_user_buyer.errors.empty?
    puts "--------#{i}---------"
    puts "Buyer (user) created"
  else
    puts new_user_buyer.errors.messages
  end

  new_user_seller = User.new(
    email:    Faker::Internet.email,
    password: "password",
    first_name:  Faker::Name.first_name,
    last_name: Faker::Name.last_name,
  )
  new_user_seller.save
  if new_user_seller.errors.empty?
    puts "Seller (user) created"
  else
    puts new_user_seller.errors.messages
  end

  new_card = Card.new(
    name: card["card"]["name"],
    color: card["card"]["colors"][0],
    card_type: card["card"]["type"],
    cmc: card["card"]["cmc"].to_s,
    power: card["card"]["power"] ,
    toughness: card["card"]["toughness"],
    img_url: card["card"]["imageUrl"],
    price_per_week: p = rand(5..200),
    user: new_user_seller
  )
  new_card.save
  if new_card.errors.empty?
    puts "Card created"
  else
    puts new_card.errors.messages
  end

  new_booking = Booking.new(
    start_date: n = Faker::Date.forward(days: rand(1..60)),
    end_date: n+14,
    total_price: p*2,
    user: new_user_buyer,
    card: new_card
  )
  new_booking.save
  if new_booking.errors.empty?
    puts "Booking created"
    puts "------------------"
  else
    puts new_booking.errors.messages
  end

  for i in (1..2)
    new_review = Review.new(name: "#{Faker::FunnyName.two_word_name}",
    comment: "#{Faker::GreekPhilosophers.quote}", stars:rand(1..5), card_id: new_card.id )
    new_review.save
    if new_review.errors.empty?
      puts "Review created"
      puts "------------------"
    else
      puts new_booking.errors.messages
    end
  end


end

