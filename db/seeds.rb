# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Api::V1::Currency.create(name: "USD", api_reference: nil, precision: 2)
Api::V1::Currency.create(name: "BTC", api_reference: 'https://api.coindesk.com/v1/bpi/currentprice/USD.json', precision: 8)

Api::V1::User.create(username: "admin", email: "admin@gmail.com", password: "admin")
Api::V1::CurrencyAccount.create(user_id: 1, currency_id: 1, balance: 10000)

puts "Seed ejecutado correctamente."