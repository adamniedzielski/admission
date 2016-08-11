#!/bin/bash
# USAGE: ./insert-pre-toc-content-to-epub.sh BOOK_FOLDER
# Requires Pandoc and the Ruby Gem epzip

# Configuration
set -e

# Variables
BOOK_FOLDER=$1
BOOK_BUILD_FOLDER="$1/build"
PRE_TOC_CONTENT_MD_SOURCE="$BOOK_FOLDER/content-pre-toc.md"
PRE_TOC_CONTENT_HTML="$BOOK_BUILD_FOLDER/content-pre-toc.html"
EPUB_BOOK="$BOOK_BUILD_FOLDER/book.epub"
EXPLODED_EPUB_DIR="$BOOK_BUILD_FOLDER/temp"
REPACKAGED_EPUB_NAME="$BOOK_BUILD_FOLDER/temp.zip"

# Argument Checking
if [ $# -ne 1 ]; then
  echo "ERROR: Must pass book folder to script"
  exit 1
fi

# Main Work
unzip -o $EPUB_BOOK -d $EXPLODED_EPUB_DIR

pandoc $PRE_TOC_CONTENT_MD_SOURCE -t html --standalone -o $PRE_TOC_CONTENT_HTML
mv $PRE_TOC_CONTENT_HTML $EXPLODED_EPUB_DIR
ruby insert-pre-toc-content.rb $EXPLODED_EPUB_DIR
ruby improve-toc.rb $EXPLODED_EPUB_DIR

rm $EPUB_BOOK
epzip $EXPLODED_EPUB_DIR $EPUB_BOOK
rm -rf $EXPLODED_EPUB_DIR
