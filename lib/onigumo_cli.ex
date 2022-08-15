defmodule Onigumo.CLI do
  def main(_args) do
    root_path = File.cwd!()
    Onigumo.Downloader.main(root_path)
  end
end
