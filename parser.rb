require_relative 'record.rb'

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
      puts "Processing #{round.name}"
      if (!File.exist?(file_path))
        next
      end

      xml_string = IO.read(file_path)
      xml_string = xml_string.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8') if !xml_string.valid_encoding?
      xml_string.scan(/<row>.*?<\/row>/).each do |str|
        coder_id = str.match(/(?<=<coder_id>).*?(?=<)/)[0]
        if (!coder_map.has_key?(coder_id))
          next
        end
        coder = coder_map[coder_id]
        div = str.match(/(?<=<division>).*?(?=<)/)[0].to_i
        rank = str.match(/(?<=<division_placed>).*?(?=<)/)
        if rank.nil?
          rank = "-"
        else
          rank = rank[0].to_i
        end
        point = str.match(/(?<=<final_points>).*?(?=<)/)[0]
        points = ["one", "two", "three"].map do |level|
          match = str.match(/(?<=<level_#{level}_status>).*?(?=<)/)
          match = match[0] if !match.nil?
          case match
          when "Passed System Test"
            str.match(/(?<=<level_#{level}_final_points>).*?(?=<)/)[0]
          when nil
            "Unopened"
          else
            match
          end
        end
        cha = [
          str.match(/(?<=<challenges_made_successful>).*?(?=<)/)[0].to_i,
          str.match(/(?<=<challenges_made_failed>).*?(?=<)/)[0].to_i
        ]
        old_rate = str.match(/(?<=<old_rating>).*?(?=<)/)[0].to_i
        new_rate = str.match(/(?<=<new_rating>).*?(?=<)/)[0].to_i
        vol = str.match(/(?<=<new_vol>).*?(?=<)/)[0].to_i
        advanced = str.match(/(?<=<advanced>).*?(?=<)/)[0]

        record = Record.new(round, coder, div, rank, point, points, cha,
                            old_rate, new_rate, vol, advanced)
        round.add_record(record)
        coder_map[coder_id].add_record(record)
      end
      round.dual(coder_map)
    end
    coder_map
  end
end
