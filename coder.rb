class Coder
  attr_reader :id, :name, :rating

  def initialize(id, name)
    @id = id
    @name = name
    @rating = 0
    @events = 0
    @events_ly = 0
    @max_rating = 0
    @vol = 0
    @submits = 0
    @solves = 0
    @cha_suc = 0
    @cha_fail = 0
    @records = Array.new
  end

  def handle_record(record)
    @rating = record.new_rate
    @max_rating = [@max_rating, @rating].max
    @events += 1
  end

  def has_records?
    !@records.empty?
  end

  def add_record(record)
    handle_record(record)
    @records << record
  end

  def suc_rate
    if @submits == 0
      0
    else
      (@solves * 100.0 / @submits).round(1)
    end
  end

  def cha_suc_rate
    if @cha_suc + @cha_fail == 0
      0
    else
      (@cha_suc * 100.0 / (@cha_suc + @cha_fail)).round(1)
    end
  end

  def stat_table_html
    <<END
<div class="statDiv">
<h2>Personal statistics</h2>
<table border="0" cellspacing="0" cellpadding="0"><tbody>
	<tr class="titleLine">
		<td><span>Handle</span></td>
		<td><span># events</span></td>
		<td><span># events last year</td>
	</tr>
	<tr>
		<td><a href="http://www.topcoder.com/tc?module=MemberProfile&cr=#{@id}" class="ratingText#{Util.rating_color(@rating)}">#{@name}</a></td>
		<td><span>#{@events}</span></td>
		<td><span>#{@events_ly}</span></td>
	</tr>
	<tr class="titleLine">
		<td><span>Rating</span></td>
		<td><span>Max rating</span></td>
		<td><span>Volatility</span></td>
	</tr>
	<tr>
		<td><span class="ratingText#{Util.rating_color(@rating)}">#{@rating}</span></td>
		<td><span class="ratingText#{Util.rating_color(@max_rating)}">#{@max_rating}</span></td>
		<td><span>#{@vol}</span></td>
	</tr>
	<tr class="titleLine">
		<td><span># submits</span></td>
		<td><span># solves</span></td>
		<td><span>Submission accuracy</span></td>
	</tr>
	<tr>
		<td><span>#{@submits}</span></td>
		<td><span>#{@sloves}</span></td>
		<td><span>#{suc_rate}%</span></td>
	</tr>
	<tr class="titleLine">
		<td><span># challenges</span></td>
		<td><span># successful challenges</span></td>
		<td><span>Challenge accuracy</span></td>
	</tr>
	<tr>
		<td><span>#{@cha_suc + @cha_fail}</span></td>
		<td><span>#{@cha_suc}</span></td>
		<td><span>#{cha_suc_rate}%</span></td>
	</tr>
</tbody></table></div>
END
  end

  def write_con_table_html(f)
  end

  def write_history_table_html(f)
    f.write(
            <<END
<div class="historyDiv">
<h2>Competition history</h2>
<table border="0" cellspacing="0" cellpadding="0"><tbody>
	<tr class="titleLine">
		<td><span>Event</span></td>
		<td><span>Div</span></td>
		<td><span>Rank</span></td>
		<td><span>Points</span></td>
		<td><span>Level 1</span></td>
		<td><span>Level 2</span></td>
		<td><span>Level 3</span></td>
		<td><span>Challenge</span></td>
		<td><span>Challenge Points</span></td>
		<td><span>Rating</span></td>
		<td><span>Rating Change</span></td>
		<td><span>Volatility</span></td>
	</tr>
END
            )
    @records.reverse_each do |record|
      f.write(record.table_string_coder)
    end
  end

end
