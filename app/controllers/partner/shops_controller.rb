class Partner::ShopsController < ApplicationController

  def index
    redirect_to partner_shop_path(current_user.shop) unless current_user.shop.nil?
  end

  def farming
    @shop = Shop.new
    @shop.stocks.build
  end

  def fishing
  end

  def create
    @shop = Shop.new(shop_params.merge(user: current_user))
    respond_to do |format|
      if @shop.save
        format.html { redirect_to partner_shop_path(@shop), notice: 'Shop was successfully created.' }
        format.json { render :show, status: :created, location: @shop }
      else
        format.html { render :farming }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_product
    #   @product = Product.find(params[:id])
    # end


    # Only allow a list of trusted parameters through.
    def shop_params
      params.require(:shop).permit(:name, stocks_attributes: [:product_reference, :price])
    end

end
