import Config

config(:onigumo, :http_client, HTTPoison)
config(:onigumo, :downloader, Onigumo.Downloader)
config(:onigumo, :parser, Onigumo.Parser)
