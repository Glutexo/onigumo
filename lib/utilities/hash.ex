defmodule Onigumo.Utilities.Hash do
  def md5(data, fmt) do
    hash(:md5, data)
    |> format(fmt)
  end

  def format(data, :bin) do
    data
  end

  def format(data, :hex) do
    Base.encode16(data, case: :lower)
  end

  def hash(func, data) do
    :crypto.hash(func, data)
  end
end
