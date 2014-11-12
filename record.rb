require_relative "util.rb"
class Record
  attr_reader :round, :coder, :div, :rank
  attr_reader :point, :points, :cha, :old_rat, :new_rate, :vol, :advanced

  def initialize(round, coder, div, rank, point,
                 points, cha, old_rate, new_rate, vol, advanced)
    @round = round
    @coder = coder
    @div = div
    @rank = rank
    @point = point
    @points = points
    @cha = cha
    @old_rate = old_rate
    @new_rate = new_rate
    @vol = vol
    @advanced = advanced
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

  def cha_score
    @cha[0] * 50 - @cha[1] * 25
  end

  def table_string_round
    s1 = <<END
	<tr>
		<td><a href="http://www.topcoder.com/stat?c=coder_room_stats&rd=#{round_id}&cr=#{coder_id}">#{@rank}</a></td>
		<td><a href="../coder/#{coder_id}.html" class="coderText#{Util.rating_color(@old_rate)}">#{coder_name}</a></td>
		<td><span>#{@point}</span></td>
END
    s2 = (type == :tour ? "<td><span>#{@advanced}</span></td>" : "")
    s3 = <<END
		<td><span class="statusText#{Util.status_color(@points[0])}">#{@points[0]}</span></td>
		<td><span class="statusText#{Util.status_color(@points[1])}">#{@points[1]}</span></td>
		<td><span class="statusText#{Util.status_color(@points[2])}">#{@points[2]}</span></td>
		<td><span>#{@cha[0]}/#{@cha[1]}</span></td>
		<td><span class="scoreText#{Util.cha_score_color(cha_score)}">#{cha_score}.0</span></td>
		<td><span class="ratingText#{Util.rating_color(@old_rate)}">#{@old_rate}</span></td>
		<td><span class="ratingText#{Util.rating_color(@new_rate)}">#{@new_rate}</span></td>
		#{Util.rate_change_html(@new_rate - @old_rate)}
		<td><span>#{@vol}</span></td>
	</tr>
END
    s1 + s2 + s3
  end

  def table_string_coder
<<END
	<tr>
		<td><a href="../rank/#{round_id}.html" class="eventText">#{round_name}</a></td>
		<td><span>#{@div}</span></td>
		<td><span>#{@rank}</span></td>
		<td><span>#{@point}</span></td>
		<td><span class="statusText#{Util.status_color(@points[0])}">#{@points[0]}</span></td>
		<td><span class="statusText#{Util.status_color(@points[1])}">#{@points[1]}</span></td>
		<td><span class="statusText#{Util.status_color(@points[2])}">#{@points[2]}</span></td>
		<td><span>#{@cha[0]}/#{@cha[1]}</span></td>
		<td><span class="scoreText#{Util.cha_score_color(cha_score)}">#{cha_score}.0</span></td>
		<td><span class="ratingText#{Util.rating_color(@new_rate)}">#{@new_rate}</span></td>
		#{Util.rate_change_html(@new_rate - @old_rate)}
		<td><span>#{@vol}</span></td>
	</tr>
END
  end

end
