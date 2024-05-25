defmodule OnigumoParserTest do
  use ExUnit.Case
  import Mox

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
end
