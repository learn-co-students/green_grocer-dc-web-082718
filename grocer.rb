require 'pry'

def consolidate_cart(cart)
  consolidated_cart = {}
  cart.uniq.each do |element|
    consolidated_cart[element.keys[0]] = element[element.keys[0]]
    consolidated_cart[element.keys[0]][:count] = cart.count(element)
  end
  return consolidated_cart
end

def apply_coupons(cart, coupons)
  
  # binding.pry 
  
  # Cart is a hash
  # Coupons is an array
  
  # If coupons is empty it should just return the cart
  return cart if coupons == {}
  
  # We will use this to add couponed items so that 
  # we aren't expanding the cart while it is iterated through
  add_later = {}
  
  # We will iterate through each coupon and each food item
  cart.each do |food, food_data|
    
    #This keeps track of how many coupons have been applied
    coupons_applied = 0
    
    coupons.each do |coupon|
      
      # If the food is equivalent to the coupon, let's 
      # apply the coupon.
      
      if coupon[:item] == food
        
        # The number of items the coupon applies to
        coupon_size = coupon[:num]
        
        # This keeps track of how many coupons are being applied
        
        
        # If the size of the coupon is equal to the
        # number of items in the cart, zero food will
        # be left and one coupon is being applied
          if coupon_size == cart[food][:count]
            coupons_applied += 1
            cart[food][:count] = 0
          elsif cart[food][:count] > coupon_size
            coupons_applied += 1
            cart[food][:count] = (cart[food][:count] - coupon_size)
          end
          
          add_later["#{food} W/COUPON"] = {
            :price => coupon[:cost],
            :clearance => cart[food][:clearance],
            :count => coupons_applied
          }
          
      end
        
    end 
  end
  
  cart.merge!(add_later)
  
  cart

end

def apply_clearance(cart)
  
  cart.each do |food, data|
    
    if data[:clearance] == true 
      data[:price] = (data[:price] * 0.8).round(1)
    end 
    
  end
  
  cart
  
end

cheese_array = [{"CHEESE"=>{:price=>6.5, :clearance=>false}},
 {"CHEESE"=>{:price=>6.5, :clearance=>false}},
 {"CHEESE"=>{:price=>6.5, :clearance=>false}}]
 
cheese_coupons = [{:item=>"CHEESE", :num=>3, :cost=>15.0}]

def checkout(cart, coupons)
  # Both cart and coupons are arrays
  
  cart = consolidate_cart(cart)

  # First, let's apply coupon discounts.
  
  # binding.pry
  
  cart = apply_coupons(cart, coupons)
  
  # binding.pry
  
  # Next, let's discount items that are on clearance.
  
  cart = apply_clearance(cart)
  
  # Finally, if the cart's total is over $100, let's
  # apply a 10% discount
  
  cart_total = 0
  
  cart.each do |food, data|
      cart_total += (data[:price] * data[:count])
  end 
  
  if cart_total > 100
    cart_total = 0
    cart.each do |food, data|
      cart_total += ((data[:price] * 0.9).round(1) * data[:count])
    end 
    return cart_total
  else 
    return cart_total
  end 

end

puts checkout(cheese_array, cheese_coupons)