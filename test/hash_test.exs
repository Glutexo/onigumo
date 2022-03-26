defmodule HashTest do
  use ExUnit.Case

  @known_md5s [
    {
      "",
      "d41d8cd98f00b204e9800998ecf8427e",
      <<212, 29, 140, 217, 143, 0, 178, 4, 233, 128, 9, 152, 236, 248,
        66, 126>>
    },
    {
      "onigumo",
      "3d8425b6ea2efe0fa78075492c719ffe",
      <<61, 132, 37, 182, 234, 46, 254, 15, 167, 128, 117, 73, 44, 113,
        159, 254>>
    },
    {
      "https://www.example.com/",
      "dcbfe5ad9e8af3495ca4582e364c1bce",
      <<220, 191, 229, 173, 158, 138, 243, 73, 92, 164, 88, 46, 54, 76,
        27, 206>>
    }
  ]

  @binary_hash <<61, 132, 37, 182, 234, 46, 254, 15, 167, 128, 117,
    73, 44, 113, 159, 254>>
  @formatted_hashes [
    {
      :bin,
      <<61, 132, 37, 182, 234, 46, 254, 15, 167, 128, 117, 73, 44, 113,
      159, 254>>
    },
    {
      :hex,
      "3d8425b6ea2efe0fa78075492c719ffe"
    }
  ]

  @data "onigumo"
  @known_hashes [
    {
      :md5,
      <<61, 132, 37, 182, 234, 46, 254, 15, 167, 128, 117, 73, 44, 113,
        159, 254>>
    },
    {
      :sha256,
      <<233, 125, 4, 183, 163, 127, 108, 247, 107, 107, 129, 176, 45,
        233, 210, 255, 218, 34, 202, 51, 112, 158, 160, 220, 15, 109,
        229, 143, 188, 196, 45, 128>>
    },
    {
      :sha512,
      <<215, 171, 58, 63, 123, 94, 7, 206, 21, 30, 63, 150, 208, 35,
        179, 69, 235, 190, 128, 183, 0, 89, 237, 183, 155, 8, 190, 178,
        233, 240, 157, 95, 187, 200, 110, 163, 116, 55, 57, 63, 73, 16,
        192, 76, 15, 236, 126, 106, 117, 209, 199, 43, 231, 192, 105,
        122, 247, 100, 47, 100, 178, 231, 31, 217>>
    }
  ]

  for {data, hash_hex, hash_bin} <- @known_md5s do
    test("MD5 known value #{inspect(data)} in hexadecimal") do
      hash = Hash.md5(unquote(data), :hex)
      assert(hash == unquote(hash_hex))
    end

    test("MD5 known value #{inspect(data)} in binary") do
      hash = Hash.md5(unquote(data), :bin)
      assert(hash == unquote(hash_bin))
    end
  end

  for {format, hash} <- @formatted_hashes do
    test("format as #{format}") do
      formatted = Hash.format(@binary_hash, unquote(format))
      assert(formatted == unquote(hash))
    end
  end
    
  for {func, hash} <- @known_hashes do
    test("hash known value with #{func}") do
      hash = Hash.hash(unquote(func), @data)
      assert(hash == unquote(hash))
    end
  end
end
