defmodule Onigumo.Component do
  @doc "Runs the component."
  @callback main(root_path :: String.t()) :: :ok
end
