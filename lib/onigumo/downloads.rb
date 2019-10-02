require('digest')
require('json')
require('net/http')
require('uri')

module Onigumo
  def download(url, path)
    doc = Net::HTTP::get(URI(url))
    target = url_to_path(url, path)
    File.write(target, doc)
  end
  
  def open_downloaded(url, path)
    path = url_to_path(url, path)
    File.new(path)
  end
  
  def write_parsed(url, path, data)
    path = url_to_path(url, path, '.json')
    File.write(path, data.to_json)
  end
  
  def url_to_filename(url)
    Digest::MD5.hexdigest(url.to_s)
  end
  
  def url_to_path(url, path, extension='')
    filename = url_to_filename(url)
    File.join(path, "#{filename}#{extension}")
  end
  
  module_function(:download, :open_downloaded, :url_to_filename, :url_to_path, :write_parsed)
end