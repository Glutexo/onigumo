defmodule OnigumoTest do
  use ExUnit.Case
  import Mox

  @url "http://onigumo.org/hello.html"
  @filename "body.html"
  @testfile_with_urls "urls.txt"

  setup(:verify_on_exit!)

  @tag :tmp_dir
  test("download", %{tmp_dir: tmp_dir}) do
    expect(
      HTTPoisonMock,
      :get!,
      fn url ->
        %HTTPoison.Response{
          status_code: 200,
          body: "Body from: #{url}"
        }
      end
    )

    filepath = Path.join(tmp_dir, @filename)
    assert(:ok == Onigumo.download(HTTPoisonMock, @url, filepath))
    assert("Body from: #{@url}" == File.read!(filepath))
  end


  @tag :tmp_dir
  test("load URL from file", %{tmp_dir: tmp_dir}) do
    filepath = Path.join(tmp_dir, @testfile_with_urls)
    content = @url <> " \n"
    File.write!(filepath, content)

    expected = [@url]
    assert(expected == Onigumo.load_urls(filepath))
  end

end
