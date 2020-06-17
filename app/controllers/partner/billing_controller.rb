class Partner::BillingController < ApplicationController
  include PartnerFilter
  before_action :authenticate_user!
  before_action :require_to_be_partner
  before_action :require_to_have_shop

  RATE = 3.0 / 100

  MONTHS = {
    1 => 'JAN',
    2 => 'FEB',
    3 => 'MAR',
    4 => 'APR',
    5 => 'MAY',
    6 => 'JUN',
    7 => 'JUL',
    8 => 'AUG',
    9 => 'SEP',
    10 => 'OCT',
    11 => 'NOV',
    12 => 'DEC'
  }

  def index
    @orders = current_user.shop.orders.distinct.order(created_at: :desc)
    if params[:month]
      @orders = @orders.where("extract(month from orders.created_at) = ?", params[:month])
    else
      @orders = @orders.where("extract(month from orders.created_at) = ?", Time.now.month)
    end
  end

end
