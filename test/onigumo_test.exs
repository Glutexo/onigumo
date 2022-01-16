defmodule OnigumoTest do
  use ExUnit.Case
  import Mox

  @url_1 "http://onigumo.org/hello.html"
  @url_2 "http://onigumo.org/bye.html"
  @filename "body.html"
  @testfile_with_urls "urls.txt"

  setup(:verify_on_exit!)

  test("download one URL") do
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

    assert(:ok == Onigumo.download(HTTPoisonMock, @url_1))
    assert("Body from: #{@url_1}" == File.read!(@filename))
  end

  @tag :tmp_dir
  test("download multiply URLs", %{tmp_dir: tmp_dir}) do
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
    filepath = Path.join(tmp_dir, @testfile_with_urls)
    content = "#{@url_1}\n#{@url_2}\n"
    File.write!(filepath, content)
    expected = "Body from: #{@url_1}\nBody from: #{@url_2}\n"
    Onigumo.main(filepath)

    assert(expected == File.read!(Onigumo.@output_filename))
  end


  @tag :tmp_dir
  test("load one URL from file", %{tmp_dir: tmp_dir}) do
    filepath = Path.join(tmp_dir, @testfile_with_urls)
    content = "#{@url_1}\n"
    File.write!(filepath, content)

    expected = [@url_1]
    assert(expected == Onigumo.load_urls(filepath))
  end


  @tag :tmp_dir
  test("load two URLs from file", %{tmp_dir: tmp_dir}) do
    filepath = Path.join(tmp_dir, @testfile_with_urls)
    content = "#{@url_1}\n#{@url_2}\n"
    File.write!(filepath, content)

    expected = [@url_1, @url_2]
    assert(expected == Onigumo.load_urls(filepath))
  end

end
