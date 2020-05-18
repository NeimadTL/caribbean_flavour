class Partner::OrdersController < ApplicationController
  include PartnerFilter
  before_action :authenticate_user!
  before_action :require_to_be_partner
  # before_action :require_to_be_shop_owner
  before_action :require_to_have_shop
  before_action :require_to_be_shop_order, only: [:show, :edit, :update]
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /partner/orders
  # GET /partner/orders.json
  def index
    # @orders = Order.left_outer_joins(:order_line_items)
    #             .where("order_line_items.shop_id = #{current_user.shop.id}").distinct
    @orders = current_user.shop.orders.distinct
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
        format.html { redirect_to partner_orders_url(@order), notice: t('.order_successfully_updated') }
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
      params.require(:order).permit(:status)
    end
end
