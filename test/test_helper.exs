ExUnit.start()

Mox.defmock(HTTPoisonMock, for: HTTPoison.Base)
Application.put_env(:onigumo, :http_client, HTTPoisonMock)
