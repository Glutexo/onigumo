defmodule Onigumo.CLI do
  @components %{
    :Downloader => Onigumo.Downloader
  }

  def main(argv) do
    {[], [component]} = OptionParser.parse!(argv, strict: [])
    {:ok, module} = Map.fetch(@components, String.to_atom(component))
    root_path = File.cwd!()
    module.main(root_path)
  end
end
