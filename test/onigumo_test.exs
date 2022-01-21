defmodule OnigumoTest do
  use ExUnit.Case
  import Mox

  @url_1 "https://onigumo.local/hello.html"
  @url_2 "https://onigumo.local/bye.html"

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

    assert(:ok == Onigumo.download(HTTPoisonMock, @url_1))
    assert("Body from: #{@url_1}\n" == File.read!(@output_filename))
  end


  test("download multiple URLs") do
    expect(
      HTTPoisonMock,
      :get!,
      2,
      fn url ->
        %HTTPoison.Response{
          status_code: 200,
          body: "Body from: #{url}\n"
        }
      end
    )

    urls = [@url_1, @url_2]
    assert([:ok, :ok] == Onigumo.download(HTTPoisonMock, urls))
    assert("Body from: #{@url_2}\n" == File.read!(@output_filename))
  end

  test("download URLs from the input file") do
    expect(
      HTTPoisonMock,
      :get!,
      2,
      fn url ->
        %HTTPoison.Response{
          status_code: 200,
          body: "Body from: #{url}\n"
        }
      end
    )

    content = "#{@url_1}\n#{@url_2}\n"
    File.write!(@input_filename, content)
    expected = "Body from: #{@url_2}\n"
    # load urls from urls_file
    # read result from some test file
    Onigumo.download(HTTPoisonMock)

    assert(expected == File.read!(@output_filename))
  end

  @tag :tmp_dir
  test("load a single URL from a file", %{tmp_dir: tmp_dir}) do
    filepath = Path.join(tmp_dir, @input_filename)
    content = "#{@url_1}\n"
    File.write!(filepath, content)

    expected = [@url_1]
    assert(expected == Onigumo.load_urls(filepath))
  end

  @tag :tmp_dir
  test("load multiple URLs from a file", %{tmp_dir: tmp_dir}) do
    filepath = Path.join(tmp_dir, @input_filename)
    content = "#{@url_1}\n#{@url_2}\n"
    File.write!(filepath, content)

    expected = [@url_1, @url_2]
    assert(expected == Onigumo.load_urls(filepath))
  end
end
