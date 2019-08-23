onigumo_files = %w(database version)
spider_files = %w(py_cz).map do |name|
  File.join('spiders', name)
end
(onigumo_files + spider_files).map do |file|
  path = File.join('onigumo', file)
  require_relative(path)
end
