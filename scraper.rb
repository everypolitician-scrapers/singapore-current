#!/bin/env ruby
# encoding: utf-8

require 'nokogiri'
require 'pry'
require 'scraperwiki'

require 'scraped_page_archive/open-uri'

def noko_for(url)
  Nokogiri::HTML(open(url).read)
end

# For now, simply fetch the pages, so they get archived

_ = noko_for('http://www.parliament.gov.sg/list-constituencies')
_ = noko_for('http://www.parliament.gov.sg/list-ncmps-and-nmps')
_ = noko_for('http://www.parliament.gov.sg/list-of-current-mps')

