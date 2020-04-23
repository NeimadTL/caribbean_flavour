class PartnerFilter

  def self.before(controller)
    unless controller.current_user.role.code == Role::PARTNER_ROLE_CODE
      controller.flash[:alert] = 'The page you were looking for requires partner access rights'
      controller.redirect_to controller.root_path
    end
  end

end
