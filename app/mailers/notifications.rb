class Notifications < ActionMailer::Base
  default from: "david@dtime.com"
  if Rails.env.development?
    default_url_options[:host] = 'localhost:3000'
  else
    default_url_options[:host] = 'dtime.r12.railsrumble.com'
  end


  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.login.subject
  #
  def login(user)
    @user = user

    mail to: user.email
  end
  def confirm(user)
    @user = user

    mail to: user.email
  end
end
