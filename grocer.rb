require 'pry'

def consolidate_cart(cart)
  new_cart = {}
  cart.each do |item|
    item.each do |name, item_data|
      if new_cart.has_key?(name) == false
        new_cart[name] = item_data
      end
      if new_cart[name].has_key?(:count)
        new_cart[name][:count] += 1
      else
        new_cart[name][:count] = 1
      end
    end
  end
  new_cart
end

def apply_coupons(cart, coupons)
  if coupons.size == 0 #Returns base cart if no coupons present
    return cart
  end

  couponed_items ={}
  cart.each do |item, item_data|
    coupons_applied = 0
    coupons.each do |coupon|
      if coupon[:item] == item
        coupon_num = coupon[:num] #number of items coupon applies to

        if coupon_num == cart[item][:count] #if coupon_num matches exactly, eliminate food from base cart and add 1 to count
          coupons_applied += 1
          cart[item][:count] = 0
        elsif cart[item][:count] > coupons_applied
          coupons_applied += 1
          cart[item][:count] = (cart[item][:count] - coupon_num)
        end

        couponed_items["#{item} W/COUPON"] = {
          price: coupon[:cost],
          clearance: cart[item][:clearance],
          count: coupons_applied
        }
      end
    end
  end
  cart.merge!(couponed_items)
  cart


end

def apply_clearance(cart)
  cart.each do |item, item_data|
    if item_data[:clearance] == true
      new_price = item_data[:price] * 0.8
      item_data[:price] = new_price.round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
   cart = consolidate_cart(cart)
   cart = apply_coupons(cart, coupons)
   cart = apply_clearance(cart)

   cart_total = 0
   cart.each do |item, item_data|
     cart_total += (item_data[:price] * item_data[:count])
   end
   if cart_total > 100
     cart_total *= 0.9
   end

cart_total.round(1)

end
