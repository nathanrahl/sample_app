class UserMailer < ActionMailer::Base
  default from: "jstoev@gmail.com"
  
  def registration_confirmation(user)
    @user = user
    mail(:to => user.email, :subject => "Registration confirmation")
  end

  def password_reset(user)
    @user= user
    mail :to => user.email, :subject => "Password Reset"
  end
end
