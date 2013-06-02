ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :sendmail
ActionMailer::Base.sendmail_settings = {
  :location => '/usr/sbin/sendmail',
  :arguments => '-i -t'
  }
