#!/bin/env ruby
# encoding: utf-8

require 'pry'

class String
  def tidy
    self.gsub(/[[:space:]]+/, ' ').strip
  end
end

class ScrapedPage
  require 'nokogiri'
  require 'scraped_page_archive/open-uri'
  # require 'open-uri/cached'

  def initialize(url:)
    @url = url
  end

  def data
    _ = noko  # always fetch the page, even if nothing uses it
   @data ||= protected_methods.map { |m| [m, send(m)] }.to_h
  end

  private

  attr_reader :url

  def noko
    @noko ||= Nokogiri::HTML(open(url).read)
  end

  def absolute_url(rel)
    return if rel.to_s.empty?
    URI.join(url, rel)
  end
end

class CurrentMPs < ScrapedPage
  protected

  def current_mps
    mp_list_table.css('tr').drop(1).map do |tr|
      td = tr.css('td')
      {
        number: td[0].text.tidy,
        name: td[1].text.tidy,
        url: absolute_url(td[1].css('a/@href').text.tidy),
        constituency: td[2].text.tidy,
      }
    end
  end

  private

  def mp_list_table
    noko.css('.view-list-of-mps-current-mps table.views-table')
  end
end

# For now, simply fetch the pages, so they get archived
_ = ScrapedPage.new(url: 'http://www.parliament.gov.sg/list-constituencies').data
_ = ScrapedPage.new(url: 'http://www.parliament.gov.sg/list-ncmps-and-nmps').data

# Archive each MP page listed on the "Current MPs" page
page = CurrentMPs.new(url: 'http://www.parliament.gov.sg/list-of-current-mps')
page.data[:current_mps].each { |mp| _ = ScrapedPage.new(url: mp[:url]).data }

