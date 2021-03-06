defmodule Admission.Builder do
  def generate_latex(config, directory) do
    {_, 0} = System.cmd(
      "pandoc",
      [
        "-V",
        "documentclass=report",
        "-V",
        "title=#{config.title}",
        "-V",
        "pdf_cover=#{config.pdf_cover}",
        "-V",
        "author=#{config.author}",
        "--latex-engine=xelatex",
        "-o",
        "build/book.latex",
        "--toc",
        "--toc-depth=4",
        "--include-before-body",
        convert_pretoc_to_latex(directory),
        "--template",
        "#{System.cwd()}/template.latex"
      ] ++ shared_args ++ chapter_file_names(config),
      cd: directory
    )
  end

  def generate_pdf(config, directory) do
    {_, 0} = System.cmd(
      "pandoc",
      [
        "-V",
        "documentclass=report",
        "-V",
        "title=#{config.title}",
        "-V",
        "pdf_cover=#{config.pdf_cover}",
        "-V",
        "author=#{config.author}",
        "--latex-engine=xelatex",
        "-o",
        "build/book.pdf",
        "--toc",
        "--toc-depth=3",
        "--include-before-body",
        convert_pretoc_to_latex(directory),
        "--template",
        "#{System.cwd()}/template.latex"
      ] ++ shared_args ++ chapter_file_names(config),
      cd: directory
    )
  end

  def generate_epub(config, directory) do
    files_to_compile = ["epub_metadata.md"] ++ chapter_file_names(config)
    {_, 0} = System.cmd(
      "pandoc",
      [
        "-o",
        "build/book.epub",
        "--toc",
        "--toc-depth=2",
        "--epub-stylesheet=#{System.cwd()}/epub.css"
      ] ++ shared_args ++ files_to_compile,
      cd: directory
    )

    {_, 0} = System.cmd("sh", ["insert-pre-toc-content-to-epub.sh", directory], cd: System.cwd())
  end

  def generate_mobi(directory) do
    {_, 0} = System.cmd(
      "ebook-convert",
      ["build/book.epub", "build/book.mobi", "--output-profile", "kindle"],
      cd: directory
    )
  end

  def generate_html_previews(config, directory) do
    ["../test-book", "build", "previews", "*.html"]
    |> Path.join
    |> Path.wildcard
    |> Enum.each(&File.rm_rf!/1)

    config
    |> chapter_file_names
    |> Enum.with_index
    |> Enum.each(&(generate_html_preview(&1, directory)))
  end

  defp shared_args do
    [
      "--standalone"
    ]
  end

  defp generate_html_preview({file, index}, directory) do
    output_file_name = String.replace_suffix(file, ".md", ".html")
    {_, 0} = System.cmd(
      "pandoc",
       [
        "--filter",
        "../chapter_sampler/wrapper",
        "-t",
        "html5",
        "--self-contained",
        "--number-offset=#{index}",
        "-o",
        "build/previews/#{output_file_name}"
      ] ++ shared_args ++ [file],
      cd: directory
    )
    remove_everything_outside_body_tag(directory, output_file_name)
  end

  defp remove_everything_outside_body_tag(directory, file_name) do
    path = [directory, "build", "previews", file_name] |> Path.join
    content = File.read!(path)
    [[_, inside_body]] = Regex.scan(~r{<body>(.*)</body>}ms, content)
    File.write!(path, inside_body)
  end

  defp chapter_file_names(config) do
    config.chapters |> Enum.map(&(&1[:file_name]))
  end

  defp convert_pretoc_to_latex(directory) do
    temp_latex_file = "build/content-pre-toc.latex"
    {_, 0} = System.cmd(
      "pandoc",
      [
        "--latex-engine=xelatex",
        "-t",
        "latex",
        "-o",
        temp_latex_file,
        "content-pre-toc.md"
      ],
      cd: directory
    )
    temp_latex_file
  end
end
