module CurrentCart
  extend ActiveSupport::Concern

  private

    def set_cart
      @cart = Cart.find(session[:cart_id])
      rescue ActiveRecord::RecordNotFound
      # @cart = Cart.create
      @cart = Cart.find(current_user.cart.id)
      session[:cart_id] = @cart.id
    end
end
