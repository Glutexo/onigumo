defmodule Mix.Tasks.Download do
  use Mix.Task

  def run(_) do
    greeting = Onigumo.hello()
    IO.puts("Onigumo says #{greeting}")
  end
end
