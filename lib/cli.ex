defmodule Onigumo.CLI do
  @components %{
    :downloader => Application.compile_env(:onigumo, :downloader)
  }

  def main(argv) do
    parsed =
      OptionParser.parse(
        argv,
        aliases: [h: :help, C: :working_dir],
        strict: [help: :boolean, working_dir: :string]
      )

    case parsed do
      {[help: true], [], []} ->
        help_message()

      {switches, [component], []} ->
        case Map.fetch(@components, String.to_atom(component)) do
          {:ok, module} ->
            {working_dir, switches} = Keyword.pop(switches, :working_dir, File.cwd!())

            case switches do
              [] -> module.main(working_dir)
              _ -> usage_message()
            end

          :error ->
            usage_message()
        end

      {_, _, [_ | _]} ->
        usage_message()

      {_, argv, _} when length(argv) != 1 ->
        usage_message()
    end
  end

  defp usage_message() do
    IO.write("""
    onigumo: invalid usage
    Usage: onigumo [OPTION]... [COMPONENT]

    Try `onigumo --help' for more options.
    """)
  end

  defp help_message() do
    components = Enum.join(Map.keys(@components), ", ")

    IO.write("""
    Usage: onigumo [OPTION]... [COMPONENT]

    Simple program that retrieves HTTP web content as structured data.

    COMPONENT\tOnigumo component to run, available: #{components}

    OPTIONS:
    -h, --help\tPrint this help
    -C, --working-dir <dir>\tChange working dir to <dir> before running
    """)
  end
end
