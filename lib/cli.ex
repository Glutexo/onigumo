defmodule Onigumo.CLI do
  @components %{
    :downloader => Application.compile_env(:onigumo, :downloader)
  }

  def main(argv) do
    case OptionParser.parse(
           argv,
           aliases: [C: :working_dir],
           strict: [working_dir: :string]
         ) do
      {switches, [component], []} ->
        {:ok, module} = Map.fetch(@components, String.to_atom(component))
        working_dir = Keyword.get(switches, :working_dir, File.cwd!())
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
    -C, --working-dir <dir>\tChange working dir to <dir> before running
    """)
  end
end
