defmodule OnigumoTest do
  use ExUnit.Case
  import Mox

  @urls [
    "https://onigumo.org/hello.html",
    "https://onigumo.org/bye.html"
  ]

  @input_filename "urls.txt"
  @output_filename "body.html"

  setup(:verify_on_exit!)

  test("download a single URL") do
    expect(
      HTTPoisonMock,
      :get!,
      fn url ->
        %HTTPoison.Response{
          status_code: 200,
          body: "Body from: #{url}\n"
        }
      end
    )

    url = Enum.at(@urls, 0)
    assert(:ok == Onigumo.download(url, HTTPoisonMock))
    assert("Body from: #{url}\n" == File.read!(@output_filename))
  end


  test("download multiple URLs") do
    expect(
      HTTPoisonMock,
      :get!,
      length(@urls),
      fn url ->
        %HTTPoison.Response{
          status_code: 200,
          body: "Body from: #{url}\n"
        }
      end
    )

    responses = Enum.map(@urls, fn _ -> :ok end)
    assert(responses == Onigumo.download(@urls, HTTPoisonMock))

    last_url = Enum.at(@urls, -1)
    assert("Body from: #{last_url}\n" == File.read!(@output_filename))
  end

  test("download URLs from the input file") do
    expect(
      HTTPoisonMock,
      :get!,
      length(@urls),
      fn url ->
        %HTTPoison.Response{
          status_code: 200,
          body: "Body from: #{url}\n"
        }
      end
    )

    content = Enum.map(@urls, &(&1 <> " \n")) |> Enum.join()
    File.write!(@input_filename, content)

    responses = Enum.map(@urls, fn _ -> :ok end)
    assert(responses == Onigumo.download(HTTPoisonMock))

    last_url = Enum.at(@urls, -1)
    expected = "Body from: #{last_url}\n"
    assert(expected == File.read!(@output_filename))
  end

  @tag :tmp_dir
  test("load URL from file", %{tmp_dir: tmp_dir}) do
    url = Enum.at(@urls, 0)

    filepath = Path.join(tmp_dir, @input_filename)
    content = url <> " \n"
    File.write!(filepath, content)

    expected = [url]
    assert(expected == Onigumo.load_urls(filepath))
  end

end
