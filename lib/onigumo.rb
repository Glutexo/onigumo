all_files = [%w(database), %w(methods), %w(version), %w(spiders py_cz)]
all_files.map do |path|
  path = File.join('onigumo', *path)
  require_relative(path)
end
