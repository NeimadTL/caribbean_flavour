class Consumer::CartsController < ApplicationController
  before_action :set_cart, only: [:show, :edit, :update, :destroy]

  # GET /consumer/carts
  # GET /consumer/carts.json
  def index
    @carts = Cart.all
  end

  # GET /consumer/carts/1
  # GET /consumer/carts/1.json
  def show
  end

  # GET /consumer/carts/new
  def new
    @cart = Cart.new
  end

  # GET /consumer/carts/1/edit
  def edit
  end

  # POST /consumer/carts
  # POST /consumer/carts.json
  def create
    @cart = Cart.new(consumer_cart_params)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /consumer/carts/1
  # PATCH/PUT /consumer/carts/1.json
  def update
    respond_to do |format|
      if @cart.update(consumer_cart_params)
        format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /consumer/carts/1
  # DELETE /consumer/carts/1.json
  def destroy
    @cart.destroy
    respond_to do |format|
      format.html { redirect_to consumer_carts_url, notice: 'Cart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cart_params
      params.fetch(:consumer_cart, {})
    end
end
