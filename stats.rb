class Stats

  def tops(array, &cmp)
    array_sorted = array.sort_by(&cmp)

    selected = []
    last_rank = 1
    last_val = ""

    array_sorted.each_with_index do |one, index|
      value = cmp.call(one)
      if index == 1 || value != last_val
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
  end

  def process_rounds(rounds)
    records = rounds.collect {|round| round.records} .flatten
    @highests = []
    records.each do |record|
      if @highests.empty? || record.new_rate > @highests.last.new_rate
        @highests << record
      end
    end
  end

  def gen_all(rounds, coders)
    process_coders(coders.values)
    process_rounds(rounds)
  end

end
