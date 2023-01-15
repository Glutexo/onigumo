defmodule OnigumoCLITest do
  use ExUnit.Case


  describe("Onigumo.CLI.main/1") do
    test("run Onigumo.CLI.main") do
      Onigumo.CLI.main(["arg1"])
    end
  end
end

