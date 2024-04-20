defmodule OnigumoCLITest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import Mox

  @invalid_arguments [
    "Downloader",
    "uploader"
  ]

  @invalid_switches [
    "--invalid",
    "-c"
  ]

  @working_dir_switches [
    "--working-dir",
    "-C"
  ]

  describe("Onigumo.CLI.main/1") do
    for argument <- @invalid_arguments do
      test("run CLI with invalid argument #{inspect(argument)}") do
        assert_raise(MatchError, fn -> Onigumo.CLI.main([unquote(argument)]) end)
      end
    end

    test("run CLI with no arguments") do
      assert usage_message_printed?(fn -> Onigumo.CLI.main([]) end)
    end

    test("run CLI with more than one argument") do
      assert usage_message_printed?(fn -> Onigumo.CLI.main(["Downloader", "Parser"]) end)
    end

    for switch <- @invalid_switches do
      test("run CLI with invalid switch #{switch}") do
        assert usage_message_printed?(fn -> Onigumo.CLI.main([unquote(switch)]) end)
      end
    end

    @tag :tmp_dir
    test("run CLI with 'downloader' argument passing cwd", %{tmp_dir: tmp_dir}) do
      expect(OnigumoDownloaderMock, :main, fn root_path -> root_path end)

      File.cd(tmp_dir)
      assert Onigumo.CLI.main(["downloader"]) == tmp_dir
    end


    for switch <- @working_dir_switches do
      @tag :tmp_dir
      test("run CLI 'downloader' with #{inspect(switch)} switch", %{tmp_dir: tmp_dir}) do
        expect(OnigumoDownloaderMock, :main, fn root_path -> root_path end)

        assert Onigumo.CLI.main(["downloader", unquote(switch), tmp_dir]) == tmp_dir
      end
    end

    defp usage_message_printed?(function) do
      output = capture_io(function)
      String.starts_with?(output, "Usage: onigumo ")
    end
  end
end
