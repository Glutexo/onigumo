defmodule OnigumoParserTest do
  use ExUnit.Case
  import Mox

  setup(:verify_on_exit!)

  describe("Onigumo.Parser.main/1") do
    @tag :tmp_dir
    test("run Parser", %{tmp_dir: tmp_dir}) do
      result = Onigumo.Parser.main(tmp_dir)
      assert(result)
    end
  end
end
