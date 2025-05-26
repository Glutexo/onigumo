defmodule OnigumoParserTest do
  use ExUnit.Case
  import Mox

  @suffixes [
    ".json",
    ""
  ]

  @files [
    {[], []},
    {["first", "second"], []},
    {["first"], ["second"]},
    {[], ["first", "second"]},
  ]

  setup(:verify_on_exit!)

  describe("Onigumo.Parser.main/1") do
    @tag :tmp_dir
    test("run Parser", %{tmp_dir: tmp_dir}) do
      _result = Onigumo.Parser.main(tmp_dir)
      assert(false)  # TODO: Do!
    end

    @tag :tmp_dir
    test("return :ok", %{tmp_dir: tmp_dir}) do
      result = Onigumo.Parser.main(tmp_dir)
      assert(result == :ok)
    end
  end

  describe("Onigumo.Parser.list_downloaded/1") do
    for {expected, unexpected} <- @files do
      @tag :tmp_dir
      test("list a directory expecting #{inspect(expected)} and not expecting #{inspect(unexpected)}", %{tmp_dir: tmp_dir}) do
        suffix = Application.get_env(:onigumo, :downloaded_suffix)

        expected = Enum.map(unquote(expected), fn file ->
          file <> suffix
        end)

        Enum.map(expected ++ unquote(unexpected), fn file ->
          path = Path.join(tmp_dir, file)
          File.write!(path, "")
        end)

        result = Onigumo.Parser.list_downloaded(tmp_dir)
        assert(MapSet.new(result) == MapSet.new(expected))
      end
    end
  end

  describe("Onigumo.Parser.is_downloaded/1") do
    test("recognize a downloaded file") do
      suffix = Application.get_env(:onigumo, :downloaded_suffix)
      path = "/test_dir/test_file#{suffix}"

      result = Onigumo.Parser.is_downloaded(path)
      assert(result == true)
    end

    for suffix <- @suffixes do
      test("do not recognize another file #{inspect(suffix)}") do
        path = "/test_dir/test_file#{unquote(suffix)}"

        result = Onigumo.Parser.is_downloaded(path)
        assert(result == false)
      end
    end
  end
end
