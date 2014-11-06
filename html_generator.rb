require_relative "html_string.rb"

class HtmlGenerator

  def wrap_html_body(f)
    f.write("<html><body>\n")
    yield
    f.write("</body></html>\n")
  end

  def write_header(f, title, css)
    f.write('<head><meta http-equiv=Content-Type content="text/html; charset=utf-8">\n')
    f.write("<title>#{title}</title>\n")
    css.each do |c|
      f.write('<link rel="stylesheet" href="#{c}" type="text/css" />\n')
    end
    f.write("</head>\n")
  end

  def gen_index(rounds)
    File.open("HTML/ZJUerXTCer.html", "w") do |f|
      wrap_html_body(f) do
        write_header(f, "ZJUerXTopCoder", ["index.css"])
        f.write('<h1 align="center">ZJUer X TopCoder</h1>\n')
        f.write('<div class="divAllRank">\n')

        # SRMs
        f.write('<div class="divSRM">\n')
        f.write('<h2>Single Round Match</h2>\n')
        f.write('<table border="0" cellspacing="0" cellpadding="0"><tbody>\n')
        f.write('<tr class="titleLine"><td><span>Event</span></td><td><span>Date</span></td></tr>\n')
        srms = rounds.select {|round| round.type == :srm}
        srms.reverse_each do |round|
          f.write("#{round.table_string}\n")
        end
        f.write('</tbody></table></div>\n')

        # Tours
        f.write('<div class="divTour">\n')
        f.write('<h2>Tournament</h2>\n')
        f.write('<table border="0" cellspacing="0" cellpadding="0"><tbody>\n')
	f.write('<tr class="titleLine"><td><span>Event</span></td><td><span>Date</span></td></tr>\n')
        tours = rounds.select {|round| round.type == :tour}
        tours.reverse_each do |round|
          f.write("#{round.table_string}\n")
        end
        f.write('</tbody></table></div>\n')

        # Stats & Others
        f.write(INDEX_SIDE_BAR)
      end
    end
  end

  def gen_round(round)
    File.open("HTML/round/#{round.id}.html", "w") do |f|
      wrap_html_body(f) do
        write_header(f, round.name, ["../rank.css"])
        f.write('<h1><a href="http://www.topcoder.com/stat?c=round_stats&rd=#{round.id}" class="eventText">#{round.name}</a></h1>\n')
        f.write('<div>\n')
        # Div 1
        f.write('<h2>Div 1</h2>\n')
        f.write('<table border="0" cellspacing="0" cellpadding="0"><tbody>\n')
        f.write(ROUND_TABLE_HEADER)
        round.div_records
      end
    end
  end

  def gen_coder(coder)
  end

  def gen_all(rounds, coders)
    gen_index(rounds)
    rounds.each {|round| gen_round(round) if round.has_records?}
    coders.each {|coder| gen_coder(coder)}
  end

end
