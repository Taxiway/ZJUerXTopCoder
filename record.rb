class Record
  attr_reader :round_id, :coder_id, :div
  attr_reader :point, :points, :cha, :old_rat, :new_rate, :vol

  def initialize(round_id, coder_id, div, point, points, cha,
                 old_rate, new_rate, vol)
    @round_id = round_id
    @coder_id = coder_id
    @div = div
    @point = point
    @points = points
    @cha = cha
    @old_rate = old_rate
    @new_rate = new_rate
    @vol = vol
  end

end
