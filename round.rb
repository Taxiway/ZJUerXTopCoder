class Round
  attr_reader :id, :name, :type, :date

  def initialize(id, name, type, date)
    @id = id
    @name = name
    @type = type
    @date = date
    @records = {1 => Array.new, 2 => Array.new}
  end

  def add_record(record)
    @records[record.div] << record
  end
end
