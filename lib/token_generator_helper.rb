module TokenGeneratorHelper

  def self.generate_confirmation_token
    loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token unless User.where(:confirmation_token => random_token).exists?
    end
  end

end
