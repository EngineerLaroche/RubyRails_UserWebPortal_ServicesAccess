#**************************************************************
# USER EMAIL
#**************************************************************
class UserMailer < ApplicationMailer

  #***********************************
  # Email activation compte user
  #***********************************
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  #*************************************
  # Email reinitialisation mot de passe
  #*************************************
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
