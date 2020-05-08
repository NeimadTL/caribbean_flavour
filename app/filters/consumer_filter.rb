module ConsumerFilter

  def require_to_be_consumer
    unless current_user.role.code == Role::CONSUMER_ROLE_CODE
      redirect_with_alert("The page you were looking for requires consumer access rights", root_url)
    end
  end

  def require_to_be_cart_owner
    id = params[:cart_id] || params[:id]
    unless current_user.cart.id == id.to_i
      redirect_with_alert("You are not the owner of this cart", root_url)
    end
  end

  def require_to_be_order_owner
    order = Order.find(params[:id])
    unless current_user.id == order.user.id
      redirect_with_alert("You are not the owner of this order", root_url)
    end
  end

  def require_to_be_cart_owner_item
    line_item = LineItem.find(params[:id])
    unless current_user.cart.id == line_item.cart.id
      redirect_with_alert("This product is not in your cart", root_url)
    end
  end

  private
  
    def redirect_with_alert(msg, url)
      flash[:alert] = msg
      redirect_to url
    end

end
