module ConsumerFilter

  def require_to_be_consumer
    unless current_user.role.code == Role::CONSUMER_ROLE_CODE
      flash[:alert] = 'The page you were looking for requires consumer access rights'
      redirect_to root_path
    end
  end

  def require_to_be_cart_owner
    id = params[:id] || params[:cart_id]
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

end
