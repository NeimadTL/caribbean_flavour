class Consumer::OrdersController < ApplicationController
  include CurrentCart
  include ConsumerFilter
  before_action :authenticate_user!
  before_action :require_to_be_consumer
  before_action :require_to_be_cart_owner, only: [:new, :create]
  before_action :require_to_be_order_owner, only: [:show, :destroy] # :edit and :update may need to be added (see routes comment)
  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :set_shop, only: [:new, :create]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.where(user_id: current_user.id)
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params.merge(user: current_user))
    
    respond_to do |format|
      if @order.save
        @order.add_line_item(@cart.line_items_of(@shop))
        format.html { redirect_to consumer_order_url(@order), notice: t('.order_successfully_created') }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to consumer_orders_url, notice: t('.order_successfully_destroyed') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    def set_shop
      @shop = Shop.find(params[:shop_id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:delivery_option_code)
    end
end
