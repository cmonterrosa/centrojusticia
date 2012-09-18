# Carlos Monterrosa (cmonterrosa@gmail.com.)
require 'base64'

module Security

  def generate_token
    Base64::encode64(rand(10).to_s)
  end
  
  def validate_token(token)
    (Base64::decode64(token.to_s) =~ /^\d{1}$/) ? true : false
  end

end
