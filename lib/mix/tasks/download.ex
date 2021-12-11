defmodule Mix.Tasks.Download do
  use Mix.Task

  def run(_) do
    Onigumo.download()
  end
end
