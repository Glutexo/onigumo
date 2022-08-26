import Config

config(:onigumo, :input_path, "urls.txt")
config(:onigumo, :downloaded_suffix, ".raw")

env = config_env()
import_config("#{env}.exs")
