require "pry"

def consolidate_cart(cart)
  newHash = {}

  cart.each do |item, item_info|
    item.each do |food, food_facts|
      newHash[food] = {}
    end
  end
  newHash

  cart.each do |item, item_info|
    item.each do |food, food_facts|
      food_facts.each do |key, value|
        newHash[food][key] = value
        newHash[food][:count] = 0
      end
    end
  end
  newHash
  cart.each do |item, item_info|
    item.each do |food, food_facts|
      if newHash.include?(food)
        newHash[food][:count] += 1
      end
    end
  end
  newHash
end


def apply_coupons(cart, coupons)
  newCart = cart

  coupons.each do |info, coupon_hashes|
    info.each do |key, value|
      if cart.keys.include?(info[:item])

        items_required = info[:num]
        items_in_cart = cart[info[:item]].fetch(:count)

        if items_in_cart >= items_required
          coupon_deals = (items_in_cart / items_required).floor
          remainder = items_in_cart % items_required
          food_name = info[:item]
          discounted_items = "#{food_name} W/COUPON"
          newCart[discounted_items] = {:price => info[:cost], :clearance => cart[food_name][:clearance], :count => coupon_deals}
          newCart[info[:item]][:count] = remainder
        end
      end
    end
  end
  newCart
end








def apply_clearance(cart)
  newCart = {}

  cart.each do |item, item_info|
    item_info.each do |key, value|
      if item_info[:clearance] == false
        newCart[item] = item_info
      elsif item_info[:clearance] == true

        discounted_price = item_info[:price] * 0.8
        newCart[item] = {:price => discounted_price.round(2), :clearance => true, :count => cart[item][:count]}

      end
    end
  end
  newCart
end



def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)

  price = 0

  cart.each do |item, item_info|
    price += item_info[:count] * item_info[:price]
  end

  price

  if price > 100
    final_price = price * 0.9
  else
    final_price = price
  end
  final_price
end
