#!/bin/env ruby
# encoding: utf-8

require 'nokogiri'
require 'pry'
require 'scraperwiki'

# require 'open-uri/cached'
require 'scraped_page_archive/open-uri'

def noko_for(url)
  # warn "Fetching #{url}"
  Nokogiri::HTML(open(url).read)
end

# For now, simply fetch the pages, so they get archived

_ = noko_for('http://www.parliament.gov.sg/list-constituencies')
_ = noko_for('http://www.parliament.gov.sg/list-ncmps-and-nmps')


LIST_PAGE = 'http://www.parliament.gov.sg/list-of-current-mps'
noko = noko_for(LIST_PAGE)
noko.css('.view-list-of-mps-current-mps table a[href*="/mp/"]/@href').each do |href|
  _ = noko_for( URI.join(LIST_PAGE, href.text) )
end

