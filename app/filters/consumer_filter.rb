module ConsumerFilter

  def require_to_be_consumer
    unless current_user.role.code == Role::CONSUMER_ROLE_CODE
      redirect_with_alert(t('.requires_consumer_access_rights'), root_url)
    end
  end

  def require_to_be_cart_owner
    id = params[:cart_id] || params[:id]
    unless current_user.cart.id == id.to_i
      redirect_with_alert(t('.require_to_be_cart_owner'), root_url)
    end
  end

  def require_to_be_order_owner
    order = Order.find(params[:id])
    unless current_user.id == order.user.id
      redirect_with_alert(t('.require_to_be_order_owner'), root_url)
    end
  end

  def require_to_be_cart_owner_item
    line_item = LineItem.find(params[:id])
    unless current_user.cart.id == line_item.cart.id
      redirect_with_alert(t('.require_to_be_cart_owner_item'), root_url)
    end
  end

  def show_no_delivery_message
    if user_signed_in?
      shop = Shop.find(params[:id])
      unless shop.cities.include?(current_user.city)
        @no_delivery_msg = t('.no_delivery_msg')
      end
    end
  end

  def require_delivery_in_user_city
    unless @stock.shop.cities.include?(current_user.city)
      redirect_to consumer_shop_url(@stock.shop), alert: t('.no_delivery_msg')
    end
  end

  def show_home_delivery_minimum_amount
    shop = Shop.find(params[:shop_id])
    orders_amount = @cart.total_price_for(@cart.line_items_of(shop))
    unless orders_amount >= shop.minimum_delivery_price
      @home_delivery_mininum_amount_msg = t('.home_delivery_mininum_amount_msg', min_amount: shop.minimum_delivery_price)
    end
  end

  def require_minimum_amount_for_home_delivery
    shop = Shop.find(params[:shop_id])
    orders_amount = @cart.total_price_for(@cart.line_items_of(@shop))
    if orders_amount < shop.minimum_delivery_price && params[:order][:delivery_option_code].to_i == DeliveryOption::CUSTOMER_PLACE_OPTION_CODE
      redirect_to(consumer_cart_url(@cart), alert: t('.home_delivery_mininum_amount_msg', min_amount: @shop.minimum_delivery_price))
    end
  end

  def require_ordered_status
    order = Order.find(params[:id])
    unless order.status_id == Order::STATUS.key('ordered_status')
      redirect_with_alert(t('.require_ordered_status'), consumer_order_url(order))
    end

  end

  private

    def redirect_with_alert(msg, url)
      flash[:alert] = msg
      redirect_to url
    end

end
