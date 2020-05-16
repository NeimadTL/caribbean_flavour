class Partner::ShopsController < ApplicationController
  include PartnerFilter
  before_action :authenticate_user!
  before_action :require_to_be_partner
  before_action :require_to_have_shop, only: [:show, :edit, :update]
  before_action :require_to_be_shop_owner, only: [:show, :edit, :update]
  before_action :set_shop, only: [:show, :edit, :update]
  before_action :allow_one_shop_only, only: [:new, :create]

  def index
    redirect_to partner_shop_url(current_user.shop) unless current_user.shop.nil?
  end

  def new
    @shop = Shop.new
  end

  def create
    @shop = Shop.new(shop_params.merge(user: current_user))
    respond_to do |format|
      if @shop.save
        format.html { redirect_to partner_shop_url(@shop), notice: t('.shop_successfully_created') }
        format.json { render :show, status: :created, location: @shop }
      else
        format.html { render :new }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @shop.update(shop_params)
        format.html { redirect_to partner_shop_url(@shop), notice: t('.shop_successfully_updated') }
        format.json { render :show, status: :ok, location: @shop }
      else
        format.html { render :edit }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop
      @shop = Shop.find(params[:id])
    end


    # Only allow a list of trusted parameters through.
    def shop_params
      params.require(:shop).permit(:name, :product_category_code, delivery_option_ids: [])
    end

end
