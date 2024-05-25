defmodule Onigumo.Parser do
  @moduledoc """
  Web scraper
  """
  @behaviour Onigumo.Component

  @impl Onigumo.Component
  def main(root_path) do
    root_path
    |> list_downloaded()
    |> Enum.map(&IO.puts(&1))

    :ok
  end

  defp list_downloaded(path) do
    path
    |> File.ls!()
    |> Enum.filter(&is_downloaded(&1))
  end

  def is_downloaded(path) do
    suffix = Application.get_env(:onigumo, :downloaded_suffix)
    Path.extname(path) == suffix
  end
end
