defmodule OnigumoTest do
  use ExUnit.Case
  import Mox

  @urls [
    "http://onigumo.org/hello.html",
    "http://onigumo.org/bye.html"
  ]
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

    url = Enum.at(@urls, 0)
    assert(:ok == Onigumo.download(HTTPoisonMock, url))
    assert("Body from: #{url}" == File.read!(@filename))
  end


  @tag :tmp_dir
  test("load a single URL form a file", %{tmp_dir: tmp_dir}) do
    url = Enum.at(@urls, 0)
    
    filepath = Path.join(tmp_dir, @testfile_with_urls)
    content = url <> " \n"
    File.write!(filepath, content)

    expected = [url]
    assert(expected == Onigumo.load_urls(filepath))
  end

  @tag :tmp_dir
  test("load multiple URLs from a file", %{tmp_dir: tmp_dir}) do
    filepath = Path.join(tmp_dir, @testfile_with_urls)
    content = Enum.map(@urls, &(&1 <> " \n")) |> Enum.join()
    File.write!(filepath, content)

    assert(@urls == Onigumo.load_urls(filepath))
  end
end
