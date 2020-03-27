class CustomisedRegistrationsController < Devise::RegistrationsController

  @@user_symbols = [
    :username, :firstname, :lastname,
    :phone_number, :city, :street,
    :additional_address_information,
    :postcode, :country, :email,
    :password, :password_confirmation
  ]

  def create
    super
  end

  def update
    super
  end

  private

    def sign_up_params
      params.require(resource_name).permit(@@user_symbols)
    end

    def account_update_params
      params.require(resource_name).permit(@@user_symbols.push(:current_password))
    end

end
