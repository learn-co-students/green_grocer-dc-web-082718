require 'pry'
require 'bigdecimal'
require 'bigdecimal/util'

def consolidate_cart(cart)
  h_consolidated = {}
  cart.uniq.each { | h_item |
    h_item.each { | item, h_info |
      h_consolidated[item] = h_info.merge( { count: cart.count(h_item)} )
    }
  }

  h_consolidated
end

def apply_coupons(cart, coupons)

  coupons.each { | coupon |
    item = coupon[:item]

    if cart[item] && cart[item][:count] >= coupon[:num] then
      cart[item][:count] -= coupon[:num]

      if cart[item + " W/COUPON"]
        cart[item + " W/COUPON"][:count] += 1
      else
        cart[item + " W/COUPON"] = {price: coupon[:cost], clearance: cart[item][:clearance], count: 1}
      end
    end
  }

cart
end

def apply_clearance(cart)

    cart.each { | item, h_info |

      if cart[item][:clearance]
        if cart[item][:price]
          cart[item][:price] = (cart[item][:price] * 0.8).round(2)
        end
      end

    }
  # binding.pry
  cart
end

def checkout(cart, coupons)
  total = 0
  consolidated_cart = consolidate_cart(cart)

  # if !coupons.empty?
    coupons_cart = apply_coupons(consolidated_cart, coupons)
    finalized_cart = apply_clearance(coupons_cart)
  # else
  #   # finalized_cart = consolidated_cart
  # end

  finalized_cart.each { | item, h_info |
    # if item == "BEER" then binding.pry end
    total += h_info[:price] * h_info[:count]
  }
  if total > 100 then total *= 0.9 end

  total
end
