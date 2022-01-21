defmodule OnigumoTest do
  use ExUnit.Case
  import Mox

  @url_1 "http://onigumo.org/hello.html"
  @url_2 "http://onigumo.org/bye.html"

  @input_filename "urls.txt"
  @output_filename "body.html"

  setup(:verify_on_exit!)

  test("download one URL") do
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

    assert(:ok == Onigumo.download(@url_1, HTTPoisonMock))
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
    assert([:ok, :ok] == Onigumo.download(urls, HTTPoisonMock))
    assert("Body from: #{@url_2}\n" == File.read!(@output_filename))
  end

  test("integration test") do
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
    Onigumo.save_urls_contents(HTTPoisonMock)

    assert(expected == File.read!(@output_filename))
  end

  test("load one URL from file") do
    content = "#{@url_1}\n"
    File.write!(@input_filename, content)

    expected = [@url_1]
    assert(expected == Onigumo.load_urls())
  end

  test("load two URLs from file") do
    content = "#{@url_1}\n#{@url_2}\n"
    File.write!(@input_filename, content)

    expected = [@url_1, @url_2]
    assert(expected == Onigumo.load_urls())
  end
end
