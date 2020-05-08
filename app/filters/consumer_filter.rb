module ConsumerFilter

  def require_to_be_consumer
    unless current_user.role.code == Role::CONSUMER_ROLE_CODE
      flash[:alert] = 'The page you were looking for requires consumer access rights'
      redirect_to root_path
    end
  end

  def require_to_be_cart_owner
    id = params[:cart_id] || params[:id]
    unless current_user.cart.id == id.to_i
      flash[:alert] = "You are not the owner of this cart"
      redirect_to root_url
    end
  end

  def require_to_be_order_owner
    order = Order.find(params[:id])
    unless current_user.id == order.user.id
      flash[:alert] = "You are not the owner of this order"
      redirect_to root_url
    end
  end

  def require_to_be_cart_owner_item
    line_item = LineItem.find(params[:id])
    unless current_user.cart.id == line_item.cart.id
      flash[:alert] = "This product is not in your cart"
      redirect_to root_url
    end
  end

end
