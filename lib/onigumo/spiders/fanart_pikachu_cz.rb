module Onigumo
  module Spiders
    class FanartPikachuCZ
      BASE_URI = 'https://fanart.pikachu.cz'
      ALL_PICS_PATH = '/content/pictures.php'
      
      class << self
        def download_all_pictures(db)
          all_pics_uri = URI.join(BASE_URI, ALL_PICS_PATH)
          db.add_download(all_pics_uri)
        end
      end
    end
  end
end