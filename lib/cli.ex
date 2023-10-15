defmodule Onigumo.CLI do
  def main(argv) do
    {[], [component]} = OptionParser.parse!(argv, strict: [])
    module = Module.safe_concat("Onigumo", component)
    root_path = File.cwd!()
    module.main(root_path)
  end
end
