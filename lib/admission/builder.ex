defmodule Admission.Builder do
  def generate_pdf(config, directory) do
    {_, 0} = System.cmd(
      "pandoc",
      [
        "-V",
        "documentclass=report",
        "-V",
        "title=#{config.title}",
        "-V",
        "author=#{config.author}",
        "-o",
        "build/book.pdf",
        "--toc",
        "--toc-depth=1"
      ] ++ shared_args ++ config.chapters,
      cd: directory
    )
  end

  def generate_epub(config, directory) do
    files_to_compile = ["epub_metadata.md"] ++ config.chapters
    {_, 0} = System.cmd(
      "pandoc",
      [
        "-o",
        "build/book.epub",
        "--toc",
        "--toc-depth=1"
      ] ++ shared_args ++ files_to_compile,
      cd: directory
    )
  end

  def generate_mobi(directory) do
    {_, 0} = System.cmd(
      "ebook-convert",
      ["build/book.epub", "build/book.mobi"],
      cd: directory
    )
  end

  def generate_html_previews(config, directory) do
    ["../test-book", "build", "previews", "*.html"]
    |> Path.join
    |> Path.wildcard
    |> Enum.each(&File.rm_rf!/1)

    config.chapters
    |> Enum.with_index
    |> Enum.each(&(generate_html_preview(&1, directory)))
  end

  defp shared_args do
    [
      "--number-sections",
      "--standalone",
      "--filter=../headings/headings"
    ]
  end

  defp generate_html_preview({file, index}, directory) do
    {_, 0} = System.cmd(
      "pandoc",
       [
        "--filter",
        "../chapter_sampler/chapter_sampler",
        "-t",
        "html5",
        "--self-contained",
        "--number-offset=#{index}",
        "-o",
        "build/previews/#{index}.html"
      ] ++ shared_args ++ [file],
      cd: directory
    )
  end
end
