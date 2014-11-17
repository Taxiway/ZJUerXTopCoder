require_relative "html_writer.rb"

class Stats

  include HtmlWriter
  def tops(array, &cmp)
    array_sorted = array.sort_by(&cmp)

    selected = []
    last_rank = 1
    last_val = ""

    array_sorted.each_with_index do |one, index|
      value = cmp.call(one)
      if index == 0 || value != last_val
        last_rank = index + 1
      end
      last_val = value
      break if last_rank > 20
      selected << [last_rank, one]
    end
    selected
  end

  def process_coders(coders)
    active_coders = coders.select {|coder| coder.active?}
    cha_coders = coders.select {|coder| coder.cha_number >= 20}
    sub_coders = coders.select {|coder| coder.submits >= 20}
    @top_rating = tops(coders) {|coder| -coder.rating}
    @top_rating_active = tops(active_coders) {|coder| -coder.rating}
    @top_max = tops(coders) {|coder| -coder.max_rating}
    @top_max_active = tops(active_coders) {|coder| -coder.max_rating}

    @top_cha_suc_rate = tops(cha_coders) {|coder| -coder.cha_suc_rate}
    @top_cha_points = tops(coders) {|coder| -coder.cha_points}
    @top_cha_points_avg = tops(cha_coders) {|coder| -coder.cha_points_avg}

    @top_suc_rate = tops(sub_coders) {|coder| -coder.suc_rate}
    @top_events = tops(coders) {|coder| -coder.events}
    @top_events_ly = tops(coders) {|coder| -coder.events_ly}
    @top_cham = tops(coders) {|coder| -coder.color_change}
    @zjuers = coders.collect {|coder| coder.has_records?}
  end

  def process_rounds(rounds)
    records_div = [1, 2].collect do |div|
      rounds.collect{|round| round.div_records(div)} .flatten
    end
    records = rounds.collect {|round| round.records} .flatten
    @highests = []
    records.each do |record|
      if @highests.empty? || record.new_rate > @highests.last.new_rate
        @highests << record
      end
    end
    @top_cha_records = tops(records) {|record| -record.cha_points}
    @top_vol = tops(records) {|record| -record.vol}
    @div_winner = records_div.collect do |records|
      records.collect {|record| record.rank == 1}
    end
    @onsites = records.collect {|record| record.onsite?}
  end

  def gen_rank_html(file_name, title, lists, headers, attributes)
    File.open("HTML/stats/#{file_name}.html", "w") do |f|
      wrap_html_body(f) do
        write_header(f, title, ["../stats.css"])
        f.write(<<END
<div class="rankTable">
<h2>#{title}</h2>
<table border="0" cellspacing="0" cellpadding="0"><tbody>
	<tr class="titleLine">
END
                )
        headers.each do |header|
          f.write("		<td><span>#{header}</span></td>\n")
        end
        f.write("	</tr>\n")

        lists.each do |index, item|
          f.write("	<tr>\n")
          f.write("		<td><span>#{index}</span></td>\n")
          attributes.each do |attribute|
            f.write("		<td>#{item.method(attribute).call}</td>\n")
          end
          f.write("	</tr>\n")
        end

        f.write("</tbody></table></div>\n")
        f.write(back_link_html(1))
      end
    end
  end

  def gen_htmls()
    gen_rank_html("toprating", "Top 20 with highest rating", @top_rating,
                  ["Rank", "Handle", "Rating", "# events", "Last event"],
                  [:handle_html_inner_link, :rating_html, :events_html,
                    :last_event_html])
    gen_rank_html("topratingactive", "Top 20 with highest rating with at least one event in recent 6 months", @top_rating_active,
                  ["Rank", "Handle", "Rating", "# events", "Last event"],
                  [:handle_html_inner_link, :rating_html, :events_html,
                    :last_event_html])
    gen_rank_html("topmaxrating", "Top 20 with highest max rating", @top_max,
                  ["Rank", "Handle", "Max rating", "# events", "Last event"],
                  [:handle_html_inner_link, :max_rating_html, :events_html,
                    :last_event_html])
    gen_rank_html("topmaxratingactive", "Top 20 with highest max rating with at least one event in recent 6 months", @top_max_active,
                  ["Rank", "Handle", "Max rating", "# events", "Last event"],
                  [:handle_html_inner_link, :max_rating_html, :events_html,
                    :last_event_html])

    gen_rank_html("chasucrate", "Top 20 challenge success rate (with at least 20 challenges)", @top_cha_suc_rate,
                  ["Rank", "Handle", "# succ. challenges", "# total challenges", "Succ. rate", "# events"],
                  [:handle_html_inner_link, :cha_suc_html, :cha_total_html,
                    :cha_suc_rate_html, :events_html])
    gen_rank_html("chapointstotal", "Top 20 challenge points in total (with at least 20 challenges)", @top_cha_points,
                  ["Rank", "Handle", "Total Challenge points", "# succ. challenges", "# failed challenges", "# events"],
                  [:handle_html_inner_link, :cha_points_html, :cha_suc_html,
                    :cha_fail_html, :events_html])
    gen_rank_html("chapointsavg", "Top 20 challenge points in average (with at least 20 challenges)", @top_cha_points_avg,
                  ["Rank", "Handle", "Average challenge points",
                    "Total Challenge points", "# events"],
                  [:handle_html_inner_link, :cha_points_avg_html,
                    :cha_points_html, :events_html])

    gen_rank_html("sucrate", "Top 20 submission success rate (with at least 20 submissions)", @top_suc_rate,
                  ["Rank", "Handle", "# solves", "# submissions", "Succ. rate", "# events"],
                  [:handle_html_inner_link, :solves_html, :submits_html,
                    :suc_rate_html, :events_html])
    gen_rank_html("mostevents", "Top 20 with most events", @top_events,
                  ["Rank", "Handle", "# events"],
                  [:handle_html_inner_link, :events_html])
    gen_rank_html("mosteventslastyear", "Top 20 with most events",
                  @top_events_ly, ["Rank", "Handle", "# events"],
                  [:handle_html_inner_link, :events_ly_html])
    gen_rank_html("chameleons", "Top 20 chameleons",
                  @top_cham, ["Rank", "Handle", "# changes"],
                  [:handle_html_inner_link, :color_change_html])

    gen_rank_html("chapointsin1event", "Top 20 challenge points in one event",
                  @top_cha_records, ["Rank", "Handle", "Event", "Division",
                    "Challenge points", "# succ. challenges",
                    "# failed challenges"],
                  [:handle_html_inner_link, :round_coder_html, :div_html,
                    :cha_points_html, :cha_suc_html, :cha_fail_html])
    gen_rank_html("volatile", "Top 20 most volatile",
                  @top_vol, ["Rank", "Handle", "Event", "Division",
                    "Volatility"],
                  [:handle_html_inner_link, :round_coder_html, :div_html,
                    :vol_html])

  end

  def gen_all(rounds, coders)
    process_coders(coders.values)
    process_rounds(rounds)
    gen_htmls()
  end

end
