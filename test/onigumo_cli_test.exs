defmodule OnigumoCLITest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import Mox

  @urls [
    "http://onigumo.local/hello.html",
    "http://onigumo.local/bye.html"
  ]

  @invalid_arguments [
    "Downloader",
    "uploader"
  ]

  describe("Onigumo.CLI.main/1") do
    @tag :tmp_dir
    test("run CLI with 'downloader' argument", %{tmp_dir: tmp_dir}) do
      expect(HTTPoisonMock, :start, fn -> nil end)
      expect(HTTPoisonMock, :get!, length(@urls), &HttpSupport.response/1)
      expect(OnigumoDownloaderMock, :main, fn root_path -> root_path end)

      input_path_env = Application.get_env(:onigumo, :input_path)
      input_path_tmp = Path.join(tmp_dir, input_path_env)
      input_file_content = InputSupport.url_list(@urls)
      File.write!(input_path_tmp, input_file_content)
      File.cd(tmp_dir)

      assert Onigumo.CLI.main(["downloader"]) == tmp_dir
    end

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

    test("run CLI with invalid switch") do
      assert usage_message_printed?(fn -> Onigumo.CLI.main(["--invalid"]) end)
    end

    defp usage_message_printed?(function) do
      output = capture_io(function)
      String.starts_with?(output, "Usage: onigumo ")
    end
  end
end
