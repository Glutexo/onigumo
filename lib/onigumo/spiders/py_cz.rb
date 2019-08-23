module Onigumo
  module Spiders
    class PyCz
      BASE_URI = 'https://py.cz'
      ALL_PAGES_INDEX_PATH = '/FrontPage/wikiindex'

      class << self
        def download_whole_wiki(db)
          all_pages_index_uri = URI.join(BASE_URI, ALL_PAGES_INDEX_PATH)
          db.add_download(all_pages_index_uri)
        end
      end
    end
  end
end