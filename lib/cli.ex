defmodule Onigumo.CLI do
  def main(argv) do
    {parsed_switches, [component]} = OptionParser.parse!(argv, strict: [working_dir: :string])
    module = Module.safe_concat("Onigumo", component)

    parsed_switches
    |> Keyword.get(:working_dir, File.cwd!())
    |> module.main
  end
end
