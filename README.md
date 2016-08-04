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
5. Confessions - a server for uploading the book https://github.com/jackkinsella/confessions
6. ```xelatex```
7. Fonts: [Playfair Display](https://www.fontsquirrel.com/fonts/playfair-display), [Libre Baskerville](https://www.fontsquirrel.com/fonts/libre-baskerville), and [Inconsolata](https://github.com/google/fonts/tree/master/ofl/inconsolata)

## Directories structure

```
workspace
--- admission # this library
--- my-cool-book # The folder containing the markdown for your book
--- headings # the Headings library
--- chapter_sampler # the ChapterSampler library
```

## Running

### Build Book and Upload

The following command builds all the formats of the book as well as the previews. It also uploads these to the API of a Confessions server, which should be running at CONFESSIONS_API_URL with the API token CONFESSIONS_API_TOKEN.

For this build command to work, this assumes
* you are using the directory structure given above
* that the `epub_metadata.md` and `book_config.exs` files are correctly configured in your book folder (e.g. /my-cool-book). You can download a template for your book folder [here](https://github.com/adamniedzielski/test-book)
* that a Book record exists on the Confessions server and has a slug
  matching the one given in `book_config.exs` and that a view file for
that book exists in `app/views/books/contents` with a filename that matches the slug name (using
underscores instead of hyphens)

Now for the command: in the ```admission``` directory:

```
$ CONFESSIONS_API_URL=http://localhost:3000/api/books/ CONFESSIONS_API_TOKEN=123456 ./admission ../my-cool-book
```

Your books will now appear inside /my-cool-book/build
