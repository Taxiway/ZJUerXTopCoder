require_relative "html_downloader.rb"
require_relative "round.rb"
require_relative "coder.rb"
require_relative "parser.rb"
require 'rexml/document'
require "fileutils"

class Crawler

  CRAWL_ZJUER = false
  ROUND_LIST = %q{http://community.topcoder.com/tc?module=BasicData&c=dd_round_list}
  ROUND = %q{http://www.topcoder.com/tc?module=BasicData&c=dd_round_results&rd=}

  def crawl_round_list
    downloader = Downloader.new(ROUND_LIST)
    xml_string = downloader.get_content.join("\n")
    xml = REXML::Document.new(xml_string)

    rounds = Array.new
    xml.elements.each("//row") do |c|
      id = c.elements["round_id"].get_text.value
      name = c.elements["short_name"].get_text.value
      type = :tour
      type = :srm if c.elements["round_type_desc"].get_text.value == "Single Round Match"
      date = c.elements["date"].get_text.value
      rounds << Round.new(id, name, type, date)
    end
    rounds
  end

  def crawl_round(round)
    puts "Crawling #{round.name}"
    file_path = "Rounds/#{round.id}.xml"
    if (!File.exist?(file_path))
      url = ROUND + round.id
      downloader = Downloader.new(url)
      begin
        xml_string = downloader.get_content.join("\n")
        IO.write(file_path, xml_string)
      rescue OpenURI::HTTPError
        puts "#{round.name} inavailable"
      end
    end
  end

  def crawl_zjuers
    # Read current recorded coders
    parser = Parser.new
    coder_map = parser.coders
    puts "Numbers of ZJUer in file: #{coder_map.size}"

    # Crawl for new coders
    start = 1
    loop do
      stop = start + 14
      puts "Crawling ZJUer page #{start} to #{stop}"
      url = "http://www.topcoder.com/tc?module=AdvancedSearch&sr=#{start}&er=#{stop}&sn=Zhejiang+University";
      downloader = Downloader.new(url)
      html = downloader.get_content.join("\n")

      ids = html.scan(/(?<=cr=)[\d]+/)
      names = html.scan(/(?<= class="coderText).+(?=<\/a>\n)/).map do |str|
        str[(str.index(">") + 1) ... str.length]
      end

      if (ids.length != names.length)
        p ids
        p names
        raise "# of ids != # of names"
      end

      if ids.length == 0
        break
      end

      ids.zip(names).each do |id, name|
        if !coder_map.has_key?(id)
          puts "New ZJUer found #{name}"
          coder_map[id] = Coder.new(id, name)
        end
      end
      start += 15
    end

    # Write back to file
    puts "Now Number of ZJUer #{coder_map.size}"
    File.open("Coders/ZJUer.txt", "w") do |f|
      coder_map.each do |id, coder|
        f.write("#{coder.name}\n")
        f.write("#{coder.id}\n")
      end
    end
  end

  def init_directory
    ["Rounds", "Coders", "HTML", "HTML/round", "HTML/coder"].each do |dir|
      FileUtils.mkdir(dir) if (!File.exist?(dir))
    end
  end

  def crawl_content_data
    init_directory
    crawl_zjuers if CRAWL_ZJUER
    rounds = crawl_round_list
    rounds.each do |round|
      crawl_round(round)
    end
    puts "Crawling done"
    rounds
  end
end

crawler = Crawler.new
rounds = crawler.crawl_content_data
parser = Parser.new
parser.parse_rounds(rounds)
