defmodule InputSupport do
  def prepare(urls) do
    Enum.map(urls, &(&1 <> "\n"))
    |> Enum.join()
  end
end
