defmodule OnigumoTest do
  use ExUnit.Case
  import Mox

  @url_1 "http://onigumo.org/hello.html"
  @url_2 "http://onigumo.org/bye.html"

  setup(:verify_on_exit!)

  @tag :tmp_dir
  test("download one URL", %{tmp_dir: tmp_dir}) do
    output_file = Path.join(tmp_dir, "outputfile")

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

    assert(:ok == Onigumo.download(HTTPoisonMock, @url_1, output_file))
    assert("Body from: #{@url_1}" == File.read!(output_file))
  end

  @tag :tmp_dir
  test("download multiply URLs", %{tmp_dir: tmp_dir}) do
    output_file = Path.join(tmp_dir, "outputfile")
    input_file = Path.join(tmp_dir, "inputfile")

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
    File.write!(input_file, content)
    expected = "Body from: #{@url_1}\nBody from: #{@url_2}\n"
    # load urls from urls_file
    # read result from some test file
    Onigumo.save_urls_contents(input_file, output_file)

    assert(expected == File.read!(output_file))
  end

  @tag :tmp_dir
  test("load one URL from file", %{tmp_dir: tmp_dir}) do
    filepath = Path.join(tmp_dir, "input_file")
    content = "#{@url_1}\n"
    File.write!(filepath, content)

    expected = [@url_1]
    assert(expected == Onigumo.load_urls(filepath))
  end

  @tag :tmp_dir
  test("load two URLs from file", %{tmp_dir: tmp_dir}) do
    filepath = Path.join(tmp_dir, "input_file")
    content = "#{@url_1}\n#{@url_2}\n"
    File.write!(filepath, content)

    expected = [@url_1, @url_2]
    assert(expected == Onigumo.load_urls(filepath))
  end
end
