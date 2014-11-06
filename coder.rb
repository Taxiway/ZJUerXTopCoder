class Coder
  attr_reader :id, :name

  def initialize(id, name)
    @id = id
    @name = name
    @records = Array.new
  end

  def add_record(record)
    records << record
  end
end
