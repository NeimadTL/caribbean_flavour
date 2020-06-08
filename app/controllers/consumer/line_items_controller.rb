class Consumer::LineItemsController < ApplicationController
  include CurrentCart
  include ConsumerFilter
  before_action :authenticate_user!
  before_action :require_to_be_consumer
  before_action :require_to_be_cart_owner, only: [:new, :create, :edit, :update, :destroy]
  before_action :require_to_be_cart_owner_item, only: [:edit, :update, :destroy]
  before_action :set_cart, only: [:new, :create]
  before_action :set_stock, only: [:new, :create, :edit, :update]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]
  before_action :item_in_cart_already, only: [:new]
  rescue_from ActiveRecord::RecordNotUnique, with: :invalid_cart
  before_action :require_delivery_in_user_city, only: [:new, :create]



  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
    respond_to { |format| format.js }
  end

  # GET /line_items/1/edit
  def edit
    respond_to { |format| format.js }
  end

  # POST /line_items
  # POST /line_items.json
  def create
    @line_item = @cart.line_items.build(line_item_params)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to consumer_cart_url(@line_item.cart), notice: t('.line_item_successfully_created') }
        format.json { render :show, status: :created, location: @line_item }
      else
        format.html { render :new }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to consumer_cart_url(@line_item.cart), notice: t('.line_item_successfully_updated') }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to consumer_cart_url(@line_item.cart), notice: t('.line_item_successfully_destroyed') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    def set_stock
      @stock = Stock.find(params[:stock_id])
    end

    # Only allow a list of trusted parameters through.
    def line_item_params
      params.require(:line_item).permit(:stock_id, :quantity)
    end

    def item_in_cart_already
      if @cart.line_items.find_by(stock: @stock)
        @already_in_cart_msg = t('.item_in_cart_already')
      end
    end

    def invalid_cart
      logger.error "User ##{current_user.id} attempts to add item #{@stock.product.reference} twice in cart ##{@cart.id}"
      redirect_to consumer_shop_url(@stock.shop), alert: t('.invalid_cart')
    end
end
