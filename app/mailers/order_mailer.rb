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

  def shipped_order
  end

end
