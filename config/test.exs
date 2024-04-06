import Config

config(:onigumo, :http_client, HTTPoisonMock)
config(:onigumo, :downloader, OnigumoDownloaderMock)
