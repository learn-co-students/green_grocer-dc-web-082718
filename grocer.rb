def consolidate_cart(cart)
  new_hash = {}
  cart.each do |element|
    element.each do |item, item_info|
      if !new_hash.has_key?(item)
        new_hash[item] = item_info
      end

      if new_hash[item].has_key?(:count)
        new_hash[item][:count] += 1
      else 
        new_hash[item][:count] = 1
      end
    end
  end
  new_hash
end


def apply_coupons(cart, coupons)
  new_hash = {}

  if !coupons.empty?
    cart.each do |item, item_info|
      coupons.each do |element|
        if !new_hash.has_key?(item)
          new_hash[item] = item_info
        end
      end
    end
  else new_hash = cart 
  end 

  if !coupons.empty?
    cart.each do |item, item_info|
      coupons.each do |element|
        if item == element[:item] && item_info[:count] >= element[:num] 
          new_hash["#{item} W/COUPON"] = {}
          new_hash["#{item} W/COUPON"][:price] = element[:cost]
          new_hash["#{item} W/COUPON"][:clearance] = cart[item][:clearance]
          new_hash["#{item} W/COUPON"][:count] = 0
        end
      end
    end 
      
    cart.each do |item, item_info|      
      coupons.each do |element|
        if element.has_value?(item) && item_info[:count] >= element[:num]
          new_hash[item][:count] -= element[:num]
          new_hash["#{item} W/COUPON"][:count] += 1
        end 
      end
    end   
  end
  new_hash
end


def apply_clearance(cart)
  cart.each do |item, item_info|
    if item_info[:clearance] == true  
      ans = item_info[:price] * 0.8
      item_info[:price] = ans.round(2)
    end
  end 
  cart 
end


def checkout(cart, coupons)
  sum = 0
  
  cart1 = consolidate_cart(cart)
  cart2 = apply_coupons(cart1, coupons)
  cart3 = apply_clearance(cart2)
  
  cart3.each do |item, item_info|
    sum += (item_info[:price] * item_info[:count])
  end
  
  if sum > 100
    sum *= 0.9
  end
  
  sum.round(1)
end