class Consumer::LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:new, :create]
  before_action :set_stock, only: [:new, :create, :edit, :update]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]
  before_action :item_in_cart_already, only: [:new]
  rescue_from ActiveRecord::RecordNotUnique, with: :invalid_cart



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
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    @line_item = @cart.line_items.build(line_item_params)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to consumer_cart_path(@line_item.cart), notice: 'Line item was successfully created.' }
        format.json { render :show, status: :created, location: @line_item }
      else
        puts @line_item.errors.inspect
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
        format.html { redirect_to consumer_cart_path(@line_item.cart), notice: 'Line item was successfully updated.' }
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
      format.html { redirect_to consumer_cart_path(@line_item.cart), notice: 'Line item was successfully destroyed.' }
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
        redirect_to consumer_shop_path(@stock.shop),
          alert: 'This product is already in your cart. If you want more,
          please go to your cart and increase the quantity for it'
      end
    end

    def invalid_cart
      logger.error "User ##{current_user.id} attempts to add item #{@stock.product.reference} twice in cart ##{@cart.id}"
      redirect_to consumer_shop_path(@stock.shop), alert: 'Something went wrong : invalid cart'
    end


end
