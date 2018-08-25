def consolidate_cart(cart)
  # code here
  new_cart = Hash.new

  cart.each do |item|
    item.each do |key, hash|
      new_cart[key] = {};
      new_cart[key][:count] = 0;
    end
  end
  cart.each do |item|
    item.each do |key, hash|
      new_cart[key][:count] += 1;
      hash.each do |symbol, value|
        new_cart[key][symbol] = value
      end
    end
  end
  new_cart
end

def apply_coupons(cart, coupons)
  # code here
  if coupons == []
    return cart
  end
  coupons.each do |coupon|

    coupon_key = coupon[:item]
    if cart[coupon_key] != nil
      new_key = "#{coupon_key} W/COUPON"
      temp_item = cart[coupon_key]
      if cart[coupon_key][:count] >= coupon[:num]
        if cart[new_key] == nil
          cart[new_key] = {
            :price => coupon[:cost],
            :clearance => temp_item[:clearance],
            :count => 1
          }
        else
          cart[new_key][:count] = cart[new_key][:count] + 1
        end
        cart[coupon_key][:count] = cart[coupon_key][:count] - coupon[:num]
      end
    end
  end
  cart
end
def apply_clearance(cart)
  # code here
  discount_cart = cart
  cart.each do |key, hash|
    hash.each do |symbol, value|
      if symbol == :clearance && value
        discount_cart[key][:price] = (hash[:price] * 0.8).round(2)
      end
    end
  end
  discount_cart
end

def checkout(cart, coupons)
  # code here
  d_cart = cart
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  puts d_cart
  puts "coupons: #{coupons}"
  puts cart
  puts "Total: #{total(cart)}"
  total(cart)
end



def total(cart)
  sum = 0
  cart.each do |key, hash|
    hash.each do |symbol, value|
      if symbol == :price && hash[:count] > 0
        sum += value * hash[:count]
      end
    end
  end
  sum
  if sum > 100
    return sum * 0.9
  end
  sum
end
