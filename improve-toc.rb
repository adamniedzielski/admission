#!/usr/bin/env ruby
require 'nokogiri'
# USAGE: ruby improve-toc.rb {FOLDER_CONTAINING_EXPLODED_EPUB}

FOLDER_CONTAINING_EXPLODED_EPUB = ARGV[0]
TOC_FILE="#{FOLDER_CONTAINING_EXPLODED_EPUB}/nav.xhtml"
EXPECTED_CHAPTER_COUNT = 22

doc = Nokogiri::XML(open(TOC_FILE))

chapter_list = doc.css("#toc > ol > li")

fail "chapter count has changed" if chapter_list.count != EXPECTED_CHAPTER_COUNT

seo_part="<h2>Part A: Search Engine Optimisation</h2>"
copywriting_part="<h2>Part B: Copywriting</h2>"
analytics_part="<h2>Part C: Analytics</h2>"
conversion_part="<h2>Part D: Conversion Optimisation</h2>"
stats_part="<h2>Part E: Statistical Significance</h2>"
email_part="<h2>Part F: Email Marketing</h2>"
paid_part="<h2>Part G: Paid Advertising</h2>"

chapter_list[0].add_next_sibling(seo_part)
chapter_list[9].add_next_sibling(copywriting_part)
chapter_list[10].add_next_sibling(analytics_part)
chapter_list[11].add_next_sibling(conversion_part)
chapter_list[12].add_next_sibling(stats_part)
chapter_list[13].add_next_sibling(email_part)
chapter_list[14].add_next_sibling(paid_part)

File.write(TOC_FILE, doc.to_xml)
