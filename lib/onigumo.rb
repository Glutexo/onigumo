%w(database version).each do |file|
  path = File.join('onigumo', file)
  require_relative(path)
end
