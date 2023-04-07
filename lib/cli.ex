defmodule Onigumo.CLI do
  def main([component]) do
    module = Module.safe_concat("Onigumo", component)
    root_path = File.cwd!()
    module.main(root_path)
  end
end
