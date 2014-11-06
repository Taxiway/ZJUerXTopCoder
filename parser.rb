require 'rexml/document'

class Parser

  def coders
    coder_map = Hash.new
    lines = IO.readlines("Coders/ZJUer.txt")
    pair_list = lines.zip(lines.rotate(1)).each_with_index.select {|pair, ind| ind % 2 == 0}
    pair_list.each do |pair, ind|
      name, id = pair
      name.gsub!(/\r|\n/, "")
      id.gsub!(/\r|\n/, "")
      coder_map[id] = Coder.new(id, name)
    end
    coder_map
  end

  def parse_rounds(rounds)
    coder_map = coders
    rounds.each do |round|
      file_path = "Rounds/#{round.id}.xml"
      if (!File.exist?(file_path))
        next
      end
      xml = REXML::Document.new(IO.read(file_path))

      xml.elements.each("//row") do |c|
        coder_id = c.elements["coder_id"].get_text.value
        if (!coder_map.has_key?(coder_id))
          next
        end
        div = c.elements["division"].get_text.value.to_i
        point = c.elements["final_points"].get_text.value
        points = ["one", "two", "three"].map do |level|
          case c.elements["level_#{level}_status"]
          when "Passed System Test"
            c.elements["level_#{level}_final_points"]
          when "Failed System Test"
            :fail
          when "Compiled"
            :compiled
          when "Opened"
            :opened
          when "Challenge Succeeded"
            :che
          else
            :unopened
          end
        end
        cha = [
          c.elements["challenges_made_successful"].get_text.value.to_i,
          c.elements["challenges_made_failed"].get_text.value.to_i
        ]
        old_rate = c.elements["old_rating"].get_text.value.to_i
        new_rate = c.elements["new_rating"].get_text.value.to_i
        vol = c.elements["new_vol"].get_text.value.to_i

        record = Record.new(round.id, coder_id, div, point, points, cha,
                            old_rate, new_rate, vol)
        round.add_record(record)
        coder_map.add_record(record)
        p record
      end
    end
  end
end
