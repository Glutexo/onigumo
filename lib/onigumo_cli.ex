defmodule Onigumo.CLI do
  use Application

  @impl Application
  def start(_type, _args) do
    Task.start(Onigumo, :main, [])
  end

  def main(_args) do
    Onigumo.main()
  end
end
