defmodule Onigumo.Parser do
  @moduledoc """
  Web scraper
  """

  def main(root_path) do
    root_path
    |> list_downloaded()
    |> Enum.map(&IO.puts(&1))
  end

  defp list_downloaded(path) do
    path
    |> File.ls!()
    |> Enum.filter(&is_downloaded(&1))
  end

  defp is_downloaded(path) do
    suffix = Application.get_env(:onigumo, :downloaded_suffix)
    Path.extname(path) == ".#{suffix}"
  end
end
