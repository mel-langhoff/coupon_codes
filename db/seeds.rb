# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb

require 'csv'

# Define the path to the data directory
data_directory = "db/data"

# Method to seed the merchants data from a CSV file
def seed_merchants(data_directory)
  csv_file = "#{data_directory}/merchants.csv"
  CSV.foreach(csv_file, headers: true, header_converters: :symbol) do |row|
    # Convert the row hash to a format suitable for ActiveRecord
    merchant_attributes = row.to_hash

    # Create a new merchant record using the attributes from the CSV row
    Merchant.create!(merchant_attributes)
  end
  puts "Merchants seeded successfully."
end

# Method to seed the coupons data from a CSV file
def seed_coupons(data_directory)
  csv_file = "#{data_directory}/coupons.csv"
  CSV.foreach(csv_file, headers: true, header_converters: :symbol) do |row|
    # Convert the row hash to a format suitable for ActiveRecord
    coupon_attributes = row.to_hash

    # Create a new coupon record using the attributes from the CSV row
    Coupon.create!(coupon_attributes)
  end
  puts "Coupons seeded successfully."
end

# Method to seed the customers data from a CSV file
def seed_customers(data_directory)
  csv_file = "#{data_directory}/customers.csv"
  CSV.foreach(csv_file, headers: true, header_converters: :symbol) do |row|
    # Convert the row hash to a format suitable for ActiveRecord
    customer_attributes = row.to_hash

    # Create a new customer record using the attributes from the CSV row
    Customer.create!(customer_attributes)
  end
  puts "Customers seeded successfully."
end

# Method to seed the items data from a CSV file
def seed_items(data_directory)
  csv_file = "#{data_directory}/items.csv"
  CSV.foreach(csv_file, headers: true, header_converters: :symbol) do |row|
    # Convert the row hash to a format suitable for ActiveRecord
    item_attributes = row.to_hash

    # Create a new item record using the attributes from the CSV row
    Item.create!(item_attributes)
  end
  puts "Items seeded successfully."
end

# Method to seed the invoices data from a CSV file
def seed_invoices(data_directory)
  csv_file = "#{data_directory}/invoices.csv"
  CSV.foreach(csv_file, headers: true, header_converters: :symbol) do |row|
    # Convert the row hash to a format suitable for ActiveRecord
    invoice_attributes = row.to_hash

    # Create a new invoice record using the attributes from the CSV row
    Invoice.create!(invoice_attributes)
  end
  puts "Invoices seeded successfully."
end

# Method to seed the transactions data from a CSV file
def seed_transactions(data_directory)
  csv_file = "#{data_directory}/transactions.csv"
  CSV.foreach(csv_file, headers: true, header_converters: :symbol) do |row|
    # Convert the row hash to a format suitable for ActiveRecord
    transaction_attributes = row.to_hash

    # Create a new transaction record using the attributes from the CSV row
    Transaction.create!(transaction_attributes)
  end
  puts "Transactions seeded successfully."
end

# Main method to seed the entire database
def main
  data_directory = "db/data"

  # Seed the data for each model
  seed_merchants(data_directory)
  seed_coupons(data_directory)
  seed_customers(data_directory)  
  seed_items(data_directory)
  seed_invoices(data_directory)
  seed_transactions(data_directory)

  puts "Database seeding complete."
end

# Call the main method to execute the seeding process
main
