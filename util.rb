class Util

  def self.rating_color(rating)
    case rating
    when 0
      "White"
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
    case status
    when "Challenge Succeeded"
      "Green"
    when "Failed System Test"
      "Red"
    when /\./ #Some points
      "Golden"
    else
      "White"
    end
  end

  def self.cha_score_color(score)
    if (score > 0)
      "Green"
    elsif (score < 0)
      "Red"
    else
      "White"
    end
  end

  def self.rate_change_html(delta)
    if (delta > 0)
      "<td><span class=\"ratingChangeInc\"><img src=\"../arrow_green_up.gif\"/>#{delta}</span></td>"
    elsif (delta < 0)
      "<td><span class=\"ratingChangeDec\"><img src=\"../arrow_red_down.gif\"/>#{-delta}</span></td>"
    else
      "<td><span class=\"ratingChangeNo\">0</span></td>"
    end
  end

end
