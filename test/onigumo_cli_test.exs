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

  @invalid_combinations [
    ["--help", "-C", ".", "downloader"],
    ["downloader", "-h"],
    ["downloader", "--help"]
  ]

  @working_dir_switches [
    "--working-dir",
    "-C"
  ]

  @help_switches [
    "-h",
    "--help"
  ]

  describe("Onigumo.CLI.main/1") do
    for argument <- @invalid_arguments do
      test("run CLI with invalid argument #{inspect(argument)}") do
        assert usage_message_printed?(fn -> Onigumo.CLI.main([unquote(argument)]) end)
      end
    end

    test("run CLI with no arguments") do
      assert usage_message_printed?(fn -> Onigumo.CLI.main([]) end)
    end

    test("run CLI with more than one argument") do
      assert usage_message_printed?(fn -> Onigumo.CLI.main(["Downloader", "Parser"]) end)
    end

    for switch <- @invalid_switches do
      test("run CLI with invalid switch #{inspect(switch)}") do
        assert usage_message_printed?(fn -> Onigumo.CLI.main([unquote(switch)]) end)
      end
    end

    for combination <- @invalid_combinations do
      test("run CLI with invalid combination #{inspect(combination)}") do
        assert usage_message_printed?(fn -> Onigumo.CLI.main(unquote(combination)) end)
      end
    end

    @tag :tmp_dir
    test("run CLI with 'downloader' argument passing cwd", %{tmp_dir: tmp_dir}) do
      expect(OnigumoDownloaderMock, :main, fn working_dir -> working_dir end)

      File.cd(tmp_dir)
      assert Onigumo.CLI.main(["downloader"]) == tmp_dir
    end

    for switch <- @working_dir_switches do
      @tag :tmp_dir
      test("run CLI 'downloader' with #{inspect(switch)} switch", %{tmp_dir: tmp_dir}) do
        expect(OnigumoDownloaderMock, :main, fn working_dir -> working_dir end)

        assert Onigumo.CLI.main(["downloader", unquote(switch), tmp_dir]) == tmp_dir
      end

      test("run CLI 'downloader' with #{inspect(switch)} without any value") do
        assert usage_message_printed?(fn -> Onigumo.CLI.main(["downloader", unquote(switch)]) end)
      end
    end

    for switch <- @help_switches do
      test("run CLI with #{inspect(switch)} switch") do
        assert help_message_printed?(fn -> Onigumo.CLI.main([unquote(switch)]) end)
      end
    end

      test("Usage message ends with one newline") do
        output = capture_io(fn -> Onigumo.CLI.main([]) end)
        assert not String.ends_with?(output, "\n\n")
      end

      test("Help message ends with one newline") do
        output = capture_io(fn -> Onigumo.CLI.main(["-h"]) end)
        assert not String.ends_with?(output, "\n\n")
      end

    defp usage_message_printed?(function) do
      output = capture_io(function)
      String.starts_with?(output, "onigumo: invalid usage")
    end

    defp help_message_printed?(function) do
      output = capture_io(function)
      String.starts_with?(output, "Usage: onigumo [OPTION]... [COMPONENT]")
    end
  end
end
