defmodule Onigumo.CLI do
  def main(argv) do
    {_parsed, args, _invalid} = OptionParser.parse(argv, strict: [])

    root_path = File.cwd!()
    module.main(root_path)
  end
end
