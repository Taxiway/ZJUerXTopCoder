require 'date'
require_relative 'util.rb'

class Coder
  attr_reader :id, :name, :rating, :max_rating, :submits
  attr_reader :events, :events_ly, :color_change

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
    @cooc = Hash.new(0)
    @win = Hash.new(0)
    @deuce = Hash.new(0)
    @lose = Hash.new(0)
    @color_change = 0
  end

  def handle_record(record)
    @rating = record.new_rate
    @max_rating = [@max_rating, @rating].max
    @events += 1
    today = DateTime.now
    @events_ly += 1 if today.prev_year <= record.date
    @vol = record.vol
    @submits += record.submits
    @solves += record.solves
    @cha_suc += record.cha_suc
    @cha_fail += record.cha_fail
    @color_change += 1 if Util.rating_color(@rating) != Util.rating_color(record.old_rate)
  end

  def dual(rec, records)
    records.each do |record|
      your_id = record.coder_id
      next if your_id == @id #self
      @cooc[your_id] += 1

      my_score = rec.point.to_f
      your_score = record.point.to_f
      if (my_score < your_score)
        @lose[your_id] += 1
      elsif (my_score > your_score)
        @win[your_id] += 1
      else
        @deuce[your_id] += 1
      end
    end
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
      (@solves * 100.0 / @submits).round(2)
    end
  end

  def cha_points
    @cha_suc * 50 - @cha_fail * 25
  end

  def cha_points_avg
    if @events == 0
      0
    else
      cha_points.to_f / @events
    end
  end

  def cha_suc_rate
    if cha_number == 0
      0
    else
      (@cha_suc * 100.0 / cha_number).round(2)
    end
  end

  def cha_number
    @cha_suc + @cha_fail
  end

  def active?
    limit = DateTime.now
    6.times {limit = limit.prev_month}
    !@records.empty? && @records.last.date >= limit
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
		<td><span>#{@solves}</span></td>
		<td><span>#{suc_rate}%</span></td>
	</tr>
	<tr class="titleLine">
		<td><span># challenges</span></td>
		<td><span># successful challenges</span></td>
		<td><span>Challenge accuracy</span></td>
	</tr>
	<tr>
		<td><span>#{cha_number}</span></td>
		<td><span>#{@cha_suc}</span></td>
		<td><span>#{cha_suc_rate}%</span></td>
	</tr>
</tbody></table></div>
END
  end

  def write_con_table_html(f, coders)
    f.write(<<END
<div class="dualDiv">
<h2>Cooccurrence</h2>
<table border="0" cellspacing="0" cellpadding="0"><tbody>
	<tr class="titleLine">
		<td><span>Handle</span></td>
		<td><span>Rating</span></td>
		<td><span># cooccurrence</span></td>
		<td><span>Win / Lose / Deuce</span></td>
		<td><span></span></td>
	</tr>
END
            )
    iter = @cooc.sort_by{|id, count| -count}.each
    [10, @cooc.size].min.times do
      id, count = iter.next
      coder = coders[id]
      f.write(<<END
	<tr>
		<td><a href="#{id}.html" class="ratingText#{Util.rating_color(coder.rating)}">#{coder.name}</a></td>
		<td><span class="ratingText#{Util.rating_color(coder.rating)}">#{coder.rating}</span></td>
		<td><span>#{count}</span></td>
		<td><span>#{@win[id]} / #{@lose[id]} / #{@deuce[id]}</span></td>
		<td><a href="../dual.php?handle1=#{@name}&handle2=#{coder.name}">See dual between <span class="ratingText#{Util.rating_color(rating)}">#{@name}</span> and <span class="ratingText#{Util.rating_color(coder.rating)}">#{coder.name}</span></a></td>
	</tr>
END
              )
    end
    f.write("</tbody></table></div>\n")
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
    f.write("</tbody></table></div>\n")
  end

end
