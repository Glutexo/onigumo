defmodule OnigumoTest do
  use ExUnit.Case
  import Mox

  @url "http://onigumo.org/hello.html"
  @filename "body.html"
  @testfile_with_urls "urls.txt"

  setup(:verify_on_exit!)

  test("download") do
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

    result = Onigumo.download(HTTPoisonMock, @url)
    assert(result == :ok)

    content = File.read!(@filename)
    assert(content == "Body from: #{@url}")
  end


  @tag :tmp_dir
  test("load URL from file", %{tmp_dir: tmp_dir}) do
    filepath = Path.join(tmp_dir, @testfile_with_urls)
    content = @url <> " \n"
    File.write!(filepath, content)

    urls = Onigumo.load_urls(filepath)
    assert(urls == [@url])
  end

end
