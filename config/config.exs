import Config

config(:onigumo, :input_path, "urls.txt")

env = config_env()
import_config("#{env}.exs")
