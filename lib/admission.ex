defmodule Admission do
  def main(args) do
    [directory] = args
    config = load_config(directory)
    Admission.Builder.generate_pdf(config, directory)
    Admission.Builder.generate_epub(config, directory)
    Admission.Builder.generate_mobi(directory)
    Admission.Submitter.send_files_to_api(config, directory)
  end

  defp load_config(directory) do
    {config, _} = Code.eval_file(Path.join(directory, "book_config.exs"))
    config
  end
end
