class Partner::OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /partner/orders
  # GET /partner/orders.json
  def index
    @orders = Order.joins("LEFT OUTER JOIN line_items ON line_items.order_id = orders.id
                           LEFT OUTER JOIN stocks ON line_items.stock_id = stocks.id")
                           .where("stocks.shop_id = #{current_user.shop.id}").distinct
  end

  # GET /partner/orders/1
  # GET /partner/orders/1.json
  def show
  end

  # GET /partner/orders/new
  def new
    @partner_order = Partner::Order.new
  end

  # GET /partner/orders/1/edit
  def edit
  end

  # POST /partner/orders
  # POST /partner/orders.json
  def create
    @partner_order = Partner::Order.new(partner_order_params)

    respond_to do |format|
      if @partner_order.save
        format.html { redirect_to @partner_order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @partner_order }
      else
        format.html { render :new }
        format.json { render json: @partner_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /partner/orders/1
  # PATCH/PUT /partner/orders/1.json
  def update
    respond_to do |format|
      if @partner_order.update(partner_order_params)
        format.html { redirect_to @partner_order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @partner_order }
      else
        format.html { render :edit }
        format.json { render json: @partner_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /partner/orders/1
  # DELETE /partner/orders/1.json
  def destroy
    @partner_order.destroy
    respond_to do |format|
      format.html { redirect_to partner_orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def partner_order_params
      params.fetch(:partner_order, {})
    end
end
