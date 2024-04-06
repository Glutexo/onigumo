ExUnit.start()

Mox.defmock(HTTPoisonMock, for: HTTPoison.Base)
Mox.defmock(OnigumoDownloaderMock, for: Onigumo.Component)
