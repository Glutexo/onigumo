defmodule SpiderHtmlTest do
  use ExUnit.Case

  @urls [
    "http://onigumo.local/hello.html",
    "http://onigumo.local/bye.html"
  ]
  @html ~s(<!doctype html>
<html>
    <body>
        <section id="content">
            <p class="headline">Floki</p>
            <a href="http://onigumo.local/hello.html">Hello</a>
            <a href="http://onigumo.local/bye.html">Bye</a>
            <a id="nothing"></a>
            <span data-model="user">onigumo</span>
        </section>
    </body>
</html>)

  describe("Spider.HTML.find_links/1") do
    test("find links in href attributes of 'a' tags") do
      links = Spider.HTML.find_links(@html)
      assert links == @urls
    end
  end
end
