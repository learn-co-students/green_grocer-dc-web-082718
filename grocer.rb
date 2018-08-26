def consolidate_cart(cart)
  # code here
  result = {}
  # code here
  cart.each_with_index do |item, i|
    item.each do |food, info|
      if result[food]
        result[food][:count] += 1
      else
        result[food] = info
        result[food][:count] = 1
      end
    end
  end
  result
end

def apply_coupons(cart, coupons)
  # code here
  result = {}
  # code here#
  cart.each do |food, info|
    coupons.each do |coupon|
      if food == coupon[:item] && info[:count] >= coupon[:num]
        info[:count] =  info[:count] - coupon[:num]
        if result["#{food} W/COUPON"]
          result["#{food} W/COUPON"][:count] += 1
        else
          result["#{food} W/COUPON"] = {:price => coupon[:cost], :clearance => info[:clearance], :count => 1}
        end
      end
    end
    result[food] = info
  end
  result
end


def apply_clearance(cart)
  # code here
  clearance_cart = {}
  # code here
  cart.each do |food, info|
    clearance_cart[food] = {}
    if info[:clearance] == true
      clearance_cart[food][:price] = info[:price] * 4 / 5
    else
      clearance_cart[food][:price] = info[:price]
    end
    clearance_cart[food][:clearance] = info[:clearance]
    clearance_cart[food][:count] = info[:count]
  end
  clearance_cart
end

def checkout(cart, coupons)

  total = 0
  consolidated = consolidate_cart(cart: cart)
  coupons_applied = apply_coupons(cart: consolidated, coupons: coupons)
  clearance_applied = apply_clearance(cart: coupons_applied)
  clearance_applied.each do |item|
    total += item[1][:price] * item[1][:count]
  end
  if total > 100
    total = total * 0.9
  else
    total
  end
  total
end
