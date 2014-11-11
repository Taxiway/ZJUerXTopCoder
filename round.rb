require_relative "html_strings.rb"

class Round
  attr_reader :id, :name, :type, :date

  def initialize(id, name, type, date)
    @id = id
    @name = name.gsub(/Single Round Match/, "SRM")
    @name = @name.gsub(/ - TCO14 Wildcard Sweep/, "")
    @type = type
    @date = date
    @records = {1 => Array.new, 2 => Array.new}
  end

  def has_records?
    !(@records[1].empty? && @records[2].empty?)
  end

  def add_record(record)
    @records[record.div] << record
  end

  def div_records(div)
    @records[div]
  end

  def write_records_html(f)
    # Div 1 & 2
    [1, 2].each do |div|
      records = div_records(div)
      next if records.empty?
      f.write("<div>\n")
      f.write("<h2>Div #{div}</h2>\n")
      f.write("<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tbody>\n")
      f.write(round_table_header(type == :tour))
      records.sort! do |a, b|
        if a.rank == b.rank
          a.coder_name <=> b.coder_name
        else
          if a.rank == "-"
            1
          elsif b.rank == "-"
            -1
          else
            a.rank.to_i <=> b.rank.to_i
          end
        end
      end
      records.each do |record|
        f.write(record.table_string_round)
      end
      f.write("</tbody></table></div>\n")
    end
  end

  def table_string
    <<END
<tr>
<td><a href="round/#{id}.html" class="eventText">#{name}</a></td>
<td><span class="dateText">#{date}</span></td>
</tr>
END
  end
end
