defmodule Onigumo.Parser do
  @moduledoc """
  Web scraper
  """

  def main(root_path) do
    root_path
    |> File.ls!()
    |> Enum.reject(&File.dir?(&1))
    |> Enum.reject(&String.contains?(&1, "."))
    |> Enum.join("\n")
    |> IO.puts()
  end
end
