class Partner::BillingController < ApplicationController
  include PartnerFilter
  before_action :authenticate_user!
  before_action :require_to_be_partner
  before_action :require_to_have_shop

  def index
    @orders = current_user.shop.orders.distinct.order(created_at: :desc)
  end

end
