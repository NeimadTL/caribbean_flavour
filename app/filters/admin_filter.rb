module AdminFilter

  def require_to_be_admin
    unless current_user.role.code == Role::ADMIN_ROLE_CODE
      flash[:alert] = 'The page you were looking for requires admin access rights'
      redirect_to root_path
    end
  end

end
