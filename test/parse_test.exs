defmodule ParseTest do
  use ExUnit.Case

  @urls [
    "http://onigumo.local/hello.html",
    "http://onigumo.local/bye.html"
  ]
  @html ~s("<!doctype html>
      <html>
      <body>
        <section id="content">
          <p class="headline">Floki</p>
          <a href="http://onigumo.local/hello.html">Hello</a>
          <a href="http://onigumo.local/bye.html">Bye</a>
          <span data-model="user">onigumo</span>
        </section>
      </body>
      </html>")

  test("Parsing values of href attributes in html links") do
    result = Parser.html_links(@html)
    assert result == @urls
  end
end
