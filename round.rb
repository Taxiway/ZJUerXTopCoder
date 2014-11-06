class Round
  attr_reader :id, :name, :type, :date

  def initialize(id, name, type, date)
    @id = id
    @name = name.gsub(/Single Round Match/, "SRM")
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

  def table_string
    <<END
<tr>
<td><a href="rank/#{id}.html" class="eventText">#{name}</a></td>
<td><span class="dateText">#{date}</span></td>
</tr>
END
  end
end
