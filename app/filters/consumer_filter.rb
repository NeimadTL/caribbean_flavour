module ConsumerFilter

  def require_to_be_consumer
    unless current_user.role.code == Role::CONSUMER_ROLE_CODE
      flash[:alert] = 'The page you were looking for requires consumer access rights'
      redirect_to root_path
    end
  end

  def require_to_be_cart_owner
    unless current_user.cart.id == params[:id].to_i
      flash[:alert] = "You are not the owner of this cart"
      redirect_to root_url
    end
  end

end
