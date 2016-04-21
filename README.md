# Admission

E-book build toolchain using [Pandoc](http://pandoc.org/).

## Building

```
mix deps.get
mix escript.build
```

## Requirements

1. Pandoc - http://pandoc.org/installing.html
2. Calibre with the command-line tools - https://manual.calibre-ebook.com/generated/en/ebook-convert.html
3. headings - https://github.com/adamniedzielski/headings
4. ChapterSampler - https://github.com/adamniedzielski/chapter_sampler

## Directories structure

```
workspace
--- admission
--- my-cool-book
--- headings
--- chapter_sampler
```

## Running

In the ```admission``` directory:

```
CONFESSIONS_API_URL=http://localhost:3000/api/books/ CONFESSIONS_API_TOKEN=123456 ./admission ../my-cool-book
```
