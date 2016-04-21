defmodule Admission.Submitter do
  def send_files_to_api(config, directory) do
    api_url = System.get_env |> Map.fetch!("CONFESSIONS_API_URL")
    payload = prepare_payload(directory, Enum.count(config.chapters))
    {:ok, %HTTPoison.Response{status_code: 200}} =
      HTTPoison.patch(
        "#{api_url}#{config.book_slug}",
        Poison.encode!(payload),
        headers
      )
  end

  defp prepare_payload(directory, chapters_count) do
    %{
      content_pdf: encode_file(directory, "book.pdf"),
      content_epub: encode_file(directory, "book.epub"),
      content_mobi: encode_file(directory, "book.mobi"),
      previews: previews(directory, chapters_count),
      token: System.get_env |> Map.fetch!("CONFESSIONS_API_TOKEN")
    }
  end

  defp encode_file(directory, name) do
    [directory, "build", name] |> Path.join |> File.read! |> Base.encode64
  end

  defp previews(directory, chapters_count) do
    Enum.map(0 .. chapters_count - 1, fn (index) ->
      %{
        content: encode_file(
          directory,
          Path.join("previews", "#{index}.html")
        )
      }
    end)
  end

  defp headers do
    [{'Content-Type', 'application/json'}]
  end
end
