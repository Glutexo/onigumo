require_relative('../lib/gallery_downloader/scrapers/fanart_pikachu_cz/scripts')
require('mechanize')

agent = Mechanize.new
GalleryDownloader::FanartPikachuCz::all_pictures(agent)
