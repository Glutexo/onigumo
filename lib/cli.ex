defmodule Onigumo.CLI do
  @components %{
    :downloader => Application.compile_env(:onigumo, :downloader)
  }

  def main(argv) do
    case OptionParser.parse(
           argv,
           aliases: [h: :help, C: :working_dir],
           strict: [help: :boolean, working_dir: :string]
         ) do
      {[help: true], [], []} ->
        usage_message()

      {parsed_switches, [component], []} ->
        {:ok, module} = Map.fetch(@components, String.to_atom(component))
        working_dir = Keyword.get(parsed_switches, :working_dir, File.cwd!())
        module.main(working_dir)

      _ ->
        usage_message()
    end
  end

  defp usage_message() do
    components = Enum.join(Map.keys(@components), ", ")

    IO.puts("""
    Usage: onigumo [OPTION]... [COMPONENT]

    Simple program that retrieves HTTP web content as structured data.

    COMPONENT\tOnigumo component to run, available: #{components}

    OPTIONS:
    -h, --help\t\tprint this help
    -C, --working-dir <dir>\tChange working dir to <dir> before running
    """)
  end
end
