class RegistrationMailer < ApplicationMailer
  default from: 'app92045074@heroku.com'

  def activate(user)
    @user = user

    mail to: @user.email, subject: 'Activate Account'
  end
end
