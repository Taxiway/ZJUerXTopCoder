class Util

  def self.rating_color(rating)
    case rating
    when 0
      "Write"
    when 1...900
      "Gray"
    when 900...1200
      "Green"
    when 1200...1500
      "Blue"
    when 1500...2200
      "Yellow"
    when 2200...3000
      "Red"
    else
      "Target"
    end
  end

  def self.status_color(status)

  end

end
