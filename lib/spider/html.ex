defmodule Onigumo.Spider.HTML do
  def find_links(document) do
    Floki.parse_document!(document)
    |> Floki.find("a")
    |> Floki.attribute("href")
  end
end
