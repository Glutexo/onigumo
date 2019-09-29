require('digest')
require('net/http')
require('uri')

module Onigumo
  def download(url, path)
    doc = Net::HTTP::get(URI(url))
    target = url_to_path(url, path)
    File.write(target, doc)
  end
  
  def url_to_filename(url)
    Digest::MD5.hexdigest(url.to_s)
  end
  
  def url_to_path(url, path)
    filename = url_to_filename(url)
    File.join(path, filename)
  end
  
  module_function(:download, :url_to_filename, :url_to_path)
end