import Config

config(:onigumo, :input_filename, "urls.txt")

env = config_env()
import_config("#{env}.exs")
