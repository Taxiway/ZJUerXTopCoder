#! /usr/bin/ruby

require_relative "crawler.rb"
require_relative "parser.rb"
require_relative "html_generator.rb"

crawler = Crawler.new
rounds = crawler.crawl_content_data
parser = Parser.new
coders = parser.parse_rounds(rounds)
generator = HtmlGenerator.new
generator.gen_all(rounds, coders)
