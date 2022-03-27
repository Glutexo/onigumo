defmodule Parser do
  def html_links(document) do
    Floki.parse_document!(document)
    |> Floki.find("a")
    |> Floki.attribute("href")
  end
end
