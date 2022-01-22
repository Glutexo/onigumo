defmodule Hash do
  def md5(data, fmt) do
    hash(:md5, data)
    |> format(fmt)
  end

  def format(data, :binary) do
    data
  end

  def format(data, :hex) do
    hex(data)
  end

  def hex(data) do
    Base.encode16(data, case: :lower)
  end

  def hash(func, data) do
    :crypto.hash(func, data)
  end
end
