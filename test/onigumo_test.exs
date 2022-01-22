defmodule OnigumoTest do
  use ExUnit.Case
  import Mox

  @urls [
    "https://onigumo.local/hello.html",
    "https://onigumo.local/bye.html"
  ]

  @filename "body.html"
  @testfile_with_urls "urls.txt"

  setup(:verify_on_exit!)

  test("download a single URL") do
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


  test("download multiple URLs") do
    expect(
      HTTPoisonMock,
      :get!,
      length(@urls),
      fn url ->
        %HTTPoison.Response{
          status_code: 200,
          body: "Body from: #{url}"
        }
      end
    )

    assert([:ok, :ok] == Onigumo.download(HTTPoisonMock, @urls))
    last_url = Enum.at(@urls, -1)
    assert("Body from: #{last_url}" == File.read!(@filename))
  end

  test("download URLs from the input file") do
    expect(
      HTTPoisonMock,
      :get!,
      length(@urls),
      fn url ->
        %HTTPoison.Response{
          status_code: 200,
          body: "Body from: #{url}"
        }
      end
    )

    content = Enum.map(@urls, &(&1 <> " \n")) |> Enum.join()
    File.write!(@testfile_with_urls, content)

    last_url = Enum.at(@urls, -1)
    expected = "Body from: #{last_url}"
    Onigumo.download(HTTPoisonMock)

    assert(expected == File.read!(@filename))
  end

  @tag :tmp_dir
  test("load URL from file", %{tmp_dir: tmp_dir}) do
    url = Enum.at(@urls, 0)

    filepath = Path.join(tmp_dir, @testfile_with_urls)
    content = url <> " \n"
    File.write!(filepath, content)

    expected = [url]
    assert(expected == Onigumo.load_urls(filepath))
  end
end
