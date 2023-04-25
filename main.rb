# frozen_string_literal: true

require_relative 'lib/checkout'

begin
  price_rules = ARGV[0]
  checkout = Checkout.new(price_rules)
  items = ARGV[1..]
  items.each { |item| checkout.scan(item) }

  puts "Items: #{items.join(', ')}"
  puts "Total: #{checkout.total}€"
rescue StandardError
  puts 'Could not calculate total. Please check the price rules file and the items to be scanned.'
end
