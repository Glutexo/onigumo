defmodule Onigumo.CLI do
  @components %{
    :downloader => Onigumo.Downloader
  }

  def main(argv) do
    case OptionParser.parse(argv, strict: [working_dir: :string]) do
      {parsed_switches, [component], []} ->
        {:ok, module} = Map.fetch(@components, String.to_atom(component))
        root_path = Keyword.get(parsed_switches, :working_dir, File.cwd!())
        module.main(root_path)

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
