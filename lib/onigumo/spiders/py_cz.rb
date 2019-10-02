require('nokogiri')

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
        
        def parse_all_pages_index(db, file)
          output = {links: []}
          find_all_pages_index_links(file) do |link|
            output[:links] << link 
          end
          output
        end
        
        private
        
        def find_all_pages_index_links(file)
          doc = Nokogiri::HTML(file)
          doc.xpath('/html/body/div/div[@class=\'formcontent\']/p//a[@href and not(starts-with(@href, \'#\'))]').each do |link|
            yield link['href']
          end
        end
      end
    end
  end
end