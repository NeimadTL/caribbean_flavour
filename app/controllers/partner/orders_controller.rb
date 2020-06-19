class Partner::OrdersController < ApplicationController
  include PartnerFilter
  before_action :authenticate_user!
  before_action :require_to_be_partner
  before_action :require_to_have_shop
  before_action :require_to_be_shop_order, only: [:show, :edit, :update]
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /partner/orders
  # GET /partner/orders.json
  def index
    @orders = current_user.shop.orders.distinct.order(created_at: :desc)
    @orders = @orders.paginate(page: params[:page], per_page: 10)
  end

  # GET /partner/orders/1
  # GET /partner/orders/1.json
  def show
  end

  # GET /partner/orders/1/edit
  def edit
  end

  # PATCH/PUT /partner/orders/1
  # PATCH/PUT /partner/orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        # OrderMailer.shipped_order(@order).deliver_now
        format.html { redirect_to partner_orders_url, notice: t('.order_successfully_updated') }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:status_id)
    end
end
