class Partner::StocksController < ApplicationController
  include PartnerFilter
  before_action :authenticate_user!
  before_action :require_to_be_partner
  before_action :require_to_have_shop
  before_action :require_to_be_shop_owner
  before_action :require_to_be_shop_owner_product, only: [:edit, :update, :destroy]
  before_action :set_stock, only: [:show, :edit, :update, :destroy]
  before_action :set_products, only: [:new, :create, :edit, :update]
  before_action :product_in_shop_already, only: [:create]
  rescue_from ActiveRecord::RecordNotUnique, with: :invalid_shop

  # GET /stocks
  # GET /stocks.json
  def index
    @stocks = Stock.all
  end

  # GET /stocks/1
  # GET /stocks/1.json
  def show
  end

  # GET /stocks/new
  def new
    @stock = Stock.new
  end

  # GET /stocks/1/edit
  def edit
  end

  # POST /stocks
  # POST /stocks.json
  def create
    @stock = Stock.new(stock_params.merge(shop_id: current_user.shop.id))

    respond_to do |format|
      if @stock.save
        format.html { redirect_to partner_shop_url(current_user.shop), notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { render :new }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stocks/1
  # PATCH/PUT /stocks/1.json
  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to partner_shop_url(current_user.shop), notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1
  # DELETE /stocks/1.json
  def destroy
    @stock.destroy
    respond_to do |format|
      format.html { redirect_to partner_shop_url(current_user.shop), notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    def set_products
      shop = Shop.find(params[:shop_id])
      @products = Product.where(product_category_id: shop.product_category_code)
    end

    # Only allow a list of trusted parameters through.
    def stock_params
      params.require(:stock).permit(:product_reference, :price)
    end

    def product_in_shop_already
      shop = Shop.find(params[:shop_id])
      if shop.products.find_by(reference: params[:stock][:product_reference])
        redirect_to new_partner_shop_stock_url(shop), alert: 'This product is already in your shop.'
      end
    end

    def invalid_shop
      logger.error "User ##{current_user.id} attempts to add product
        #{params[:stock][:product_reference]} twice in shop ##{params[:shop_id]}"
      redirect_to new_partner_shop_stock_url(params[:shop_id]), alert: 'Something went wrong : invalid shop'
    end
end
