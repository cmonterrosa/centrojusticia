# Carlos Monterrosa cmonterrosa@gmail.com.

module Security

  def generate_token
    return (rand(10)).to_s + Array.new(4) { (rand(122-97) + 97).chr }.join + (rand(10000)).to_s.rjust(4, "0")
  end
  
  def validate_token(token)
    (token =~ /\d{1}[a-z]{4}\d{4}/) ? true : false
  end

end
