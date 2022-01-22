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

    assert(:ok == Onigumo.download(HTTPoisonMock, @url))
    assert("Body from: #{@url}" == File.read!(@filename))
  end


  @tag :tmp_dir
  test("load URL from file", %{tmp_dir: tmp_dir}) do
    urls = [@url]

    filepath = Path.join(tmp_dir, @testfile_with_urls)
    content = urls_input(urls)
    File.write!(filepath, content)

    assert(urls == Onigumo.load_urls(filepath))
  end

  defp urls_input(urls) do
    Enum.map(urls, &(&1 <> " \n"))
    |> Enum.join()
  end
end
