defmodule Onigumo.CLI do
  @components %{
    :downloader => Onigumo.Downloader
  }

  def main(argv) do
    case OptionParser.parse(argv, strict: [working_dir: :string]) do
      {parsed_switches, [component], []} ->
        {:ok, module} = Map.fetch(@components, String.to_atom(component))
        parsed_switches
        |> Keyword.get(:working_dir, File.cwd!())
        |> module.main

      _ ->
        usage_message()
    end
  end

  defp usage_message() do
    components = Enum.join(Map.keys(@components), ", ")

    IO.puts("""
    Usage: onigumo [COMPONENT]

    Simple program that retrieves HTTP web content as structured data.

    COMPONENT\tOnigumo component to run, available: #{components}
    """)
  end
end
