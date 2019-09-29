module Onigumo
  module Spiders
    class PyCz
      BASE_URI = 'https://py.cz'
      ALL_PAGES_INDEX_PATH = '/FrontPage/wikiindex'

      class << self
        def download_whole_wiki(db)
          all_pages_index_uri = URI.join(BASE_URI, ALL_PAGES_INDEX_PATH)
          download_id = db.add_download(all_pages_index_uri)
          db.add_parse(:PyCz, :parse_all_pages_index, download_id)
        end
        
        def parse_all_pages_index

        end
      end
    end
  end
end