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

    with {switches, [component], []} <- parsed,
         {:ok, module} <- Map.fetch(@components, String.to_atom(component)) do
      working_dir = Keyword.get(switches, :working_dir, File.cwd!())
      module.main(working_dir)
    else
      {[help: true], [], []} -> usage_message()
      {_, _, [_ | _]} -> usage_message()
      {_, argv, _} when length(argv) != 1 -> usage_message()
      :error -> usage_message()
    end

    case parsed do
      {[help: true], [], []} ->
        usage_message()

      {_, _, [_ | _]} ->
        usage_message()

      {_, argv, _} when length(argv) != 1 ->
        usage_message()

      {switches, [component], []} ->
        case Map.fetch(@components, String.to_atom(component)) do
          {:ok, module} ->
            working_dir = Keyword.get(switches, :working_dir, File.cwd!())
            module.main(working_dir)

          :error ->
            usage_message()
        end
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
