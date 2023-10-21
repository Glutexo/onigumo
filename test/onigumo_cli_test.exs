defmodule OnigumoCLITest do
  use ExUnit.Case
  import Mox

  @urls [
    "http://onigumo.local/hello.html",
    "http://onigumo.local/bye.html"
  ]

  describe("Onigumo.CLI.main/1") do
    @tag :tmp_dir
    test("run CLI with 'Downloader' argument", %{tmp_dir: tmp_dir}) do
      expect(HTTPoisonMock, :start, fn -> nil end)
      expect(HTTPoisonMock, :get!, length(@urls), &HttpSupport.response/1)

      input_path_env = Application.get_env(:onigumo, :input_path)
      input_path_tmp = Path.join(tmp_dir, input_path_env)
      input_file_content = InputSupport.url_list(@urls)
      File.write!(input_path_tmp, input_file_content)
      File.cd(tmp_dir)
      Onigumo.CLI.main(["Downloader"])
    end

    test("run CLI with invalid argument") do
      assert_raise(MatchError, fn -> Onigumo.CLI.main(["Uploader"]) end)
    end

    test("run CLI with no arguments") do
      assert_raise(MatchError, fn -> Onigumo.CLI.main([]) end)
    end

    test("run CLI with more than one argument") do
      assert_raise(MatchError, fn -> Onigumo.CLI.main(["Downloader", "Parser"]) end)
    end

    test("run CLI with invalid switch") do
      assert_raise(OptionParser.ParseError, fn -> Onigumo.CLI.main(["--help"]) end)
    end
  end
end
