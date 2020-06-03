class OrderMailer < ApplicationMailer

  default from: "no-reply@example.com"

  def new_order(order, opts={})
    @order = order
  	mail(to: @order.shop.user.email)
  	opts[:from] = 'no-reply@example.com'
    opts[:reply_to] = 'no-reply@example.com'
    opts[:subject] = 'New order has been placed !'
  end

  def cancelled_order
  end

  def shipped_order(order, opts={})
    if order.status_id == Order::STATUS.key('shipped_status') &&
      order.delivery_option_code == DeliveryOption::CUSTOMER_PLACE_OPTION_CODE
      @order = order
    	mail(to: @order.user.email)
    	opts[:from] = 'no-reply@example.com'
      opts[:reply_to] = 'no-reply@example.com'
      opts[:subject] = 'Your order has been shipped'
    end
  end

end
