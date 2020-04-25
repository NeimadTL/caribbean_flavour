module ConsumerFilter

  def require_to_be_consumer
    unless current_user.role.code == Role::CONSUMER_ROLE_CODE
      flash[:alert] = 'The page you were looking for requires consumer access rights'
      redirect_to root_path
    end
  end
  
end
