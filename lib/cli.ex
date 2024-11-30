defmodule Onigumo.CLI do
  @components %{
    :downloader => Application.compile_env(:onigumo, :downloader)
  }

  def main(argv) do
    parsed = OptionParser.parse(argv, aliases: [C: :working_dir], strict: [working_dir: :string])

    with {switches, [component], []} <- parsed,
         {:ok, module} <- Map.fetch(@components, String.to_atom(component)) do
      working_dir = Keyword.get(switches, :working_dir, File.cwd!())
      module.main(working_dir)
    else
      :error -> usage_message()
      {_, _, [_ | _]} -> usage_message()
      {_, argv, _} when length(argv) != 1 -> usage_message()
      _ -> usage_message()
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
