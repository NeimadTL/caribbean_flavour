class UserMailer < Devise::Mailer

  default from: 'no-reply@example.com'

  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views


  def confirmation_instructions(record, token, opts={})
  	@user = record
  	mail(to: @user.email)
  	opts[:from] = 'no-reply@example.com'
    opts[:reply_to] = 'no-reply@example.com'
    opts[:subject] = 'Welcome to CaribbeanFlavour !'
  	super
  end

end
