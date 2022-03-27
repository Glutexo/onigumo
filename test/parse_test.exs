defmodule ParseTest do
  use ExUnit.Case

  @urls [
    "http://onigumo.local/hello.html",
    "http://onigumo.local/bye.html"
  ]

  test("Parsing values of href attributes in html links") do
    document = ~s("<!doctype html>
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

    result = Parser.html_links(document)
    assert result == @urls
  end
end
