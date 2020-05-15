module PartnerFilter

  def require_to_be_partner
    unless current_user.role.code == Role::PARTNER_ROLE_CODE
      flash[:alert] = 'The page you were looking for requires partner access rights'
      redirect_to root_path
    end
  end

  def require_to_have_shop
    if current_user.shop.nil?
      redirect_to partner_shops_url
      return
    end
  end

  def require_to_be_shop_owner
    # if current_user.shop.nil?
    #   redirect_to partner_shops_url
    #   return
    # end
    id = params[:shop_id] || params[:id]
    unless current_user.shop.id == id.to_i
      flash[:alert] = "You are not the owner of this shop"
      redirect_to root_url
    end
  end

  def allow_one_shop_only
    unless current_user.shop.nil?
      flash[:alert] = "You already have a shop"
      redirect_to root_url
    end
  end

  def require_to_be_shop_owner_product
    stock = Stock.find(params[:id])
    unless current_user.shop.id == stock.shop.id
      flash[:alert] = "This product is not in your shop"
      redirect_to root_url
    end
  end

  def require_to_be_shop_order
    order = Order.find(params[:id])
    unless current_user.shop.id == order.order_line_items.first.shop.id
      flash[:alert] = "This order does not belong to your shop"
      redirect_to root_url
    end
  end

end
