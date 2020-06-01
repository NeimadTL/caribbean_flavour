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

  def require_delivery_in_user_city
    if user_signed_in?
      shop = Shop.find(params[:id])
      unless shop.cities.include?(current_user.city)
        @no_delivery_msg = t('.no_delivery_msg')
      end
    end
  end

  def does_shop_cover_user_city
    if params[:shop_id] # when in new action
      shop = Shop.find(params[:shop_id])
    else # when show action
      shop = Order.find(params[:id]).shop
    end
    unless shop.cities.include?(current_user.city)
      @ocd_fee_msg = t('.new_order_ocd_fee_msg')
    end
  end

  def require_ordered_status
    order = Order.find(params[:id])
    unless order.status_id == 0
      redirect_with_alert(t('.require_ordered_status'), consumer_order_url(order))
    end

  end

  private

    def redirect_with_alert(msg, url)
      flash[:alert] = msg
      redirect_to url
    end

end
