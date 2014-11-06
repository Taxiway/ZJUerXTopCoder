require_relative "util.rb"

class Record
  attr_reader :round_id, :coder_id, :div
  attr_reader :point, :points, :cha, :old_rat, :new_rate, :vol

  def initialize(round_id, coder_id, name, div, rank, point, points, cha,
                 old_rate, new_rate, vol, advanced)
    @round_id = round_id
    @coder_id = coder_id
    @name = name
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

  def table_string_round
    color = Util.rating_color(old_rate)
    <<END
	<tr>
		<td><a href="http://www.topcoder.com/stat?c=coder_room_stats&rd=#{@round_id}&cr=#{@coder_id}">#{@rank}</a></td>
		<td><a href="../coder/#{@coder_id}.html" class="coderText#{color}">#{name}</a></td>
		<td><span>#{point}</span></td>
		<td><span class="statusTextGolden">201.42</span></td>
		<td><span class="statusTextWhite">Opened</span></td>
		<td><span class="statusTextWhite">Unopened</span></td>
		<td><span>0/0</span></td>
		<td><span class="scoreTextWhite">0.0</span></td>
		<td><span class="ratingTextGray">802</span></td>
		<td><span class="ratingTextGray">766</span></td>
		<td><span class="ratingChangeDec"><img src="arrow_red_down.gif"/>36</span></td>
		<td><span>276</span></td>
	</tr>
END
  end

  def table_string_coder
  end

end
