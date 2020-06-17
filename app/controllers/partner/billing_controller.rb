class Partner::BillingController < ApplicationController
  include PartnerFilter
  before_action :authenticate_user!
  before_action :require_to_be_partner
  before_action :require_to_have_shop
  # needs to be called but needs route to be updated first
  # before_action :require_to_be_shop_owner

  RATE = 3.0 / 100

  def index
    @orders = current_user.shop.orders.distinct.order(created_at: :desc)
  end

end
