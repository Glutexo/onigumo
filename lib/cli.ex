defmodule Onigumo.CLI do
  @components %{
    :downloader => Onigumo.Downloader
  }

  def main(argv) do
    {[], [component]} = OptionParser.parse!(argv, strict: [])
    {:ok, module} = Map.fetch(@components, String.to_atom(component))
    root_path = File.cwd!()
    module.main(root_path)

  defp usage_message() do
    IO.puts("Usage: ./onigumo [COMPONENT]\n")
    IO.puts("\tSimple program that retrieve http web content in structured data.\n")
    IO.puts("COMPONENT\tonigumo component to run, availables #{inspect Map.keys(@components)}")
  end
end
