#!/usr/bin/env ruby
require 'nokogiri'
# USAGE: ruby insert-pre-toc-content.rb {FOLDER_CONTAINING_EXPLODED_EPUB}

FOLDER_CONTAINING_EXPLODED_EPUB = ARGV[0]
CONTENT_FILE="#{FOLDER_CONTAINING_EXPLODED_EPUB}/content.opf"
doc = Nokogiri::XML(open(CONTENT_FILE))

new_manifest_node = '<item id="content-pre-toc" href="content-pre-toc.html" media-type="application/xhtml+xml" />'
new_spine_node = '<itemref idref="content-pre-toc"/>'

nav_manifest_node = doc.search("item")[1]
nav_manifest_node.add_next_sibling(new_manifest_node)
nav_spine_node = doc.search('itemref')[1]
nav_spine_node.add_next_sibling(new_spine_node)

File.write(CONTENT_FILE, doc.to_xml)
