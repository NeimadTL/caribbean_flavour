class Consumer::ShopsController < ApplicationController
  before_action :set_shop, only: [:show, :edit, :update, :destroy]

  # GET /consumer/shops
  # GET /consumer/shops.json
  def index
    @shops = Shop.all
  end

  # GET /consumer/shops/1
  # GET /consumer/shops/1.json
  def show
  end

  # GET /consumer/shops/new
  def new
    @shop = Consumer::Shop.new
  end

  # GET /consumer/shops/1/edit
  def edit
  end

  # POST /consumer/shops
  # POST /consumer/shops.json
  def create
    @consumer_shop = Consumer::Shop.new(consumer_shop_params)

    respond_to do |format|
      if @consumer_shop.save
        format.html { redirect_to @consumer_shop, notice: 'Shop was successfully created.' }
        format.json { render :show, status: :created, location: @consumer_shop }
      else
        format.html { render :new }
        format.json { render json: @consumer_shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /consumer/shops/1
  # PATCH/PUT /consumer/shops/1.json
  def update
    respond_to do |format|
      if @consumer_shop.update(consumer_shop_params)
        format.html { redirect_to @consumer_shop, notice: 'Shop was successfully updated.' }
        format.json { render :show, status: :ok, location: @consumer_shop }
      else
        format.html { render :edit }
        format.json { render json: @consumer_shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /consumer/shops/1
  # DELETE /consumer/shops/1.json
  def destroy
    @consumer_shop.destroy
    respond_to do |format|
      format.html { redirect_to consumer_shops_url, notice: 'Shop was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop
      @shop = Shop.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def consumer_shop_params
      params.fetch(:consumer_shop, {})
    end
end
