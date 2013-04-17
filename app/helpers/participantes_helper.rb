module ParticipantesHelper



  def hash_of_years
    hash={}
    (Time.now.year.to_i-99..Time.now.year).each do |y|
      hash[(Time.now.year-y).to_s.rjust(2, "0")] = y.to_s
    end
    return hash.sort
  end

end
