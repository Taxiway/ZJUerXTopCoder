require 'date'
require_relative "util.rb"

class Record
  attr_reader :round, :coder, :div, :rank
  attr_reader :point, :points, :cha, :old_rating, :new_rating, :vol, :advanced
  attr_reader :cha_points

  def initialize(round, coder, div, rank, point,
                 points, cha, old_rating, new_rating, vol, advanced, cha_points)
    @round = round
    @coder = coder
    @div = div
    @rank = rank
    @point = point
    @points = points
    @cha = cha
    @old_rating = old_rating
    @new_rating = new_rating
    @vol = vol
    @advanced = advanced
    @cha_points = cha_points
  end

  def round_id
    @round.id
  end

  def round_name
    @round.name
  end

  def coder_id
    @coder.id
  end

  def coder_name
    @coder.name
  end

  def type
    @round.type
  end

  def date
    DateTime.new(*(@round.date.split(/ |:|-/).map(&:to_i)))
  end

  def submits
    @points.count {|st| st != "Opened" && st != "Unopened" && st != "Compiled"}
  end

  def solves
    @points.count {|st| st =~ /\./}
  end

  def cha_suc
    @cha[0]
  end

  def cha_fail
    @cha[1]
  end

  def cha_text
    (@cha[0] == 0 ? "0" : "+" + @cha[0].to_s) + "/" +
      (@cha[1] == 0 ? "0" : "-" + @cha[1].to_s)
  end

  def onsite?
    @round.onsite?
  end

  def handle_html_inner_link
    "<a href=\"../coder/#{@coder.id}.html\" class=\"ratingText#{Util.rating_color(@new_rating)}\">#{@coder.name}</a>"
  end

  def round_coder_html
    "<a href=\"http://www.topcoder.com/stat?c=coder_room_stats&rd=#{@round.id}&cr=#{@coder.id}\" class=\"eventText\">#{@round.name}</span>"
  end

  def div_html
    "<span>#{@div}</span>"
  end

  def cha_points_html
    "<span>#{@cha_points.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse}.00</span>"
  end

  def cha_suc_html
    "<span>#{@cha[0]}</span>"
  end

  def cha_fail_html
    "<span>#{@cha[1]}</span>"
  end

  def vol_html
    "<span>#{@vol}</span>"
  end

  def date_html
    "<span class=\"dateText\">#{@round.date}</span>"
  end

  def new_rating_html
    "<span class=\"ratingText#{Util.rating_color(@new_rating)}\">#{@new_rating}</span>"
  end

  def rank_html
    "<span>#{@rank}</span>"
  end

  def table_string_round
    s1 = <<END
	<tr>
		<td><a href="http://www.topcoder.com/stat?c=coder_room_stats&rd=#{round_id}&cr=#{coder_id}">#{@rank}</a></td>
		<td><a href="../coder/#{coder_id}.html" class="coderText#{Util.rating_color(@old_rating)}">#{coder_name}</a></td>
		<td><span>#{@point}</span></td>
END
    s2 = (type == :tour ? "<td><span>#{@advanced}</span></td>" : "")
    s3 = <<END
		<td><span class="statusText#{Util.status_color(@points[0])}">#{@points[0]}</span></td>
		<td><span class="statusText#{Util.status_color(@points[1])}">#{@points[1]}</span></td>
		<td><span class="statusText#{Util.status_color(@points[2])}">#{@points[2]}</span></td>
		<td><span>#{cha_text}</span></td>
		<td><span class="scoreText#{Util.cha_score_color(cha_points)}">#{cha_points}.0</span></td>
		<td><span class="ratingText#{Util.rating_color(@old_rating)}">#{@old_rating}</span></td>
		<td><span class="ratingText#{Util.rating_color(@new_rating)}">#{@new_rating}</span></td>
		#{Util.rate_change_html(@new_rating - @old_rating)}
		<td><span>#{@vol}</span></td>
	</tr>
END
    s1 + s2 + s3
  end

  def table_string_coder
<<END
	<tr>
		<td><a href="../round/#{round_id}.html" class="eventText">#{round_name}</a></td>
		<td><span>#{@div}</span></td>
		<td><span>#{@rank}</span></td>
		<td><span>#{@point}</span></td>
		<td><span class="statusText#{Util.status_color(@points[0])}">#{@points[0]}</span></td>
		<td><span class="statusText#{Util.status_color(@points[1])}">#{@points[1]}</span></td>
		<td><span class="statusText#{Util.status_color(@points[2])}">#{@points[2]}</span></td>
		<td><span>#{cha_text}</span></td>
		<td><span class="scoreText#{Util.cha_score_color(cha_points)}">#{cha_points}.0</span></td>
		<td><span class="ratingText#{Util.rating_color(@new_rating)}">#{@new_rating}</span></td>
		#{Util.rate_change_html(@new_rating - @old_rating)}
		<td><span>#{@vol}</span></td>
	</tr>
END
  end

end
