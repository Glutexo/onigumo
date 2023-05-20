defmodule Onigumo.Parser do
  @moduledoc """
  Web scraper
  """

  def main(root_path) do
    root_path
    |> File.ls!()
	|> Enum.filter(fn filename -> Path.extname(filename) == ".raw" end)
    |> Enum.map(&IO.puts(&1))
  end
end
