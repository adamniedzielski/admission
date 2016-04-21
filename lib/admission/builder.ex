defmodule Admission.Builder do
  def generate_pdf(config, directory) do
    {_, 0} = System.cmd(
      "pandoc",
      pdf_specific_args(config) ++ shared_args ++ config.chapters,
      cd: directory
    )
  end

  def generate_epub(config, directory) do
    files_to_compile = ["epub_metadata.md"] ++ config.chapters
    {_, 0} = System.cmd(
      "pandoc",
      ["-o", "book.epub"] ++ shared_args ++ files_to_compile,
      cd: directory
    )
  end

  def generate_mobi(directory) do
    {_, 0} = System.cmd(
      "ebook-convert",
      ["book.epub", "book.mobi"],
      cd: directory
    )
  end

  defp shared_args do
    [
      "--number-sections",
      "--toc",
      "--toc-depth=1",
      "--standalone",
      "--filter=../headings/headings"
    ]
  end

  defp pdf_specific_args(config) do
    [
      "-V",
      "documentclass=report",
      "-V",
      "title=#{config.title}",
      "-V",
      "author=#{config.author}",
      "-o",
      "book.pdf"
    ]
  end
end
