defmodule Onigumo.CLI do
  def main(argv) do
    {_parsed, args, _invalid} = OptionParser.parse(argv, strict: [])

    module =
      args
      |> get_component
      |> safe_concat

    root_path = File.cwd!()
    module.main(root_path)
  end

  defp get_component([]), do: "Downloader"
  defp get_component([component | _]), do: component

  defp safe_concat(component) do
    Module.safe_concat("Onigumo", component)
  end
end
