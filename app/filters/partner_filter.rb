module PartnerFilter

  def require_to_be_partner
    unless current_user.role.code == Role::PARTNER_ROLE_CODE
      flash[:alert] = 'The page you were looking for requires partner access rights'
      redirect_to root_path
    end
  end

  def require_to_be_shop_owner
    unless current_user.shop.id == params[:id].to_i
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

end
