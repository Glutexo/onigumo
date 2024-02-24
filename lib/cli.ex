defmodule Onigumo.CLI do
  @components %{
    :downloader => Onigumo.Downloader
  }

  def main(argv) do
    try do
      {[], [component], []} = OptionParser.parse(argv, strict: [])
      component
    rescue
      MatchError -> usage_message()
    else
      component ->
        {:ok, module} = Map.fetch(@components, String.to_atom(component))
        root_path = File.cwd!()
        module.main(root_path)
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
