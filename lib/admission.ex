defmodule Admission do
  alias Admission.Builder
  alias Admission.Submitter

  def main(args) do
    [directory] = args
    config = load_config(directory)
    Builder.generate_pdf(config, directory)
    Builder.generate_epub(config, directory)
    Builder.generate_mobi(directory)
    Builder.generate_html_previews(config, directory)
    Submitter.send_files_to_api(config, directory)
  end

  defp load_config(directory) do
    {config, _} = Code.eval_file(Path.join(directory, "book_config.exs"))
    config
  end
end
