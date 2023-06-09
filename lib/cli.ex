defmodule Onigumo.CLI do
  def main(argv) do
    {parsed_switches, _, _} =
      argv
      |> parse_argv

    module =
      parsed_switches
      |> Keyword.get(:component, "Downloader")
      |> safe_concat()

    parsed_switches
    |> Keyword.get(:output, File.cwd!())
    |> module.main()
  end

  defp parse_argv(argv) do
    argv
    |> OptionParser.parse(
      aliases: [o: :output],
      strict: [component: :string, output: :string]
    )
  end

  defp safe_concat(component) do
    Module.safe_concat("Onigumo", component)
  end
end
