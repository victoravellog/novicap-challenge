# frozen_string_literal: true

require 'json'

class Checkout
  def initialize(price_rules_file)
    @price_rules = File.open(price_rules_file) { |f| JSON.parse(f.read) }
    @items = Hash.new(0)
  end

  def scan(item)
    @items[item] += 1
  end

  def total
    total = 0.0
    @items.each do |item, quantity|
      total += calculate_price(item, quantity)
    end
    total.round(2)
  end

  private

    def calculate_price(item, quantity)
      return normal_price(item, quantity) unless @price_rules[item]['discount']

      if @price_rules[item]['discount']['type'] == 'bulk'
        return calculate_bulk_price(item,
                                    quantity)
      end

      return unless @price_rules[item]['discount']['type'] == 'x-for-y'

      calculate_x_for_y_price(item, quantity)
    end

    def calculate_bulk_price(item, quantity)
      unless quantity >= @price_rules[item]['discount']['quantity']
        return normal_price(item, quantity)
      end

      @price_rules[item]['discount']['fixed_price'] * quantity
    end

    def calculate_x_for_y_price(item, quantity)
      unless quantity >= @price_rules[item]['discount']['x']
        return normal_price(item, quantity)
      end

      fixed_price = @price_rules[item]['price'] * (@price_rules[item]['discount']['y'] / @price_rules[item]['discount']['x'].to_f)
      mod = quantity % @price_rules[item]['discount']['x']

      with_fixed_price = (quantity - mod) * fixed_price
      without_fixed_price = mod * @price_rules[item]['price']

      with_fixed_price + without_fixed_price
    end

    def normal_price(item, quantity)
      @price_rules[item]['price'] * quantity
    end
end
