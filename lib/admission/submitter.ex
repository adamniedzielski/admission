defmodule Admission.Submitter do
  def send_files_to_api(config, directory) do
    api_url = System.get_env |> Map.fetch!("CONFESSIONS_API_URL")
    payload = prepare_payload(config, directory)
    {:ok, %HTTPoison.Response{status_code: 200}} =
      HTTPoison.patch(
        "#{api_url}#{config.book_slug}",
        Poison.encode!(payload),
        headers,
        [recv_timeout: 1000000]
      )
  end

  defp prepare_payload(config, directory) do
    %{
      content_pdf: encode_file(directory, "book.pdf"),
      content_epub: encode_file(directory, "book.epub"),
      content_mobi: encode_file(directory, "book.mobi"),
      previews: previews(config, directory),
      token: System.get_env |> Map.fetch!("CONFESSIONS_API_TOKEN")
    }
  end

  defp encode_file(directory, name) do
    [directory, "build", name] |> Path.join |> File.read! |> Base.encode64
  end

  defp previews(config, directory) do
    Enum.map(config.chapters, fn ([title: title, file_name: file_name]) ->
      output_file_name = String.replace_suffix(file_name, ".md", ".html")
      %{
        title: title,
        content: encode_file(
          directory,
          Path.join("previews", output_file_name)
        )
      }
    end)
  end

  defp headers do
    [{'Content-Type', 'application/json'}]
  end
end
