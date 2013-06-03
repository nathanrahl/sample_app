module TokenGeneratorHelper

  def self.generate_token(column)
    loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token unless User.where(column => random_token).exists?
    end
  end

end
