require('sequel')
require('sqlite3')

module Onigumo
  class Database
    def initialize(base_path)
      db_path = File.join(base_path, "database.db")
      db_exists = File.exists?(db_path)
      @conn = Sequel.connect("sqlite://#{db_path}")
      init_schema unless db_exists
    end
    
    def add_download(url)
      @conn[:downloads] << {url: url.to_s, downloaded: 0}
    end
    
    def add_action(spider, meth)
      @conn[:actions] << {spider: spider, method: meth, performed: 0}
    end
    
    private
    def init_schema
      @conn.create_table(:downloads) do
        primary_key(:id)
        String(:url)
        Integer(:downloaded)  # boolean
      end
      
      @conn.create_table(:actions) do
        primary_key(:id)
        String(:spider)
        String(:method)
        Integer(:performed)  # boolean
      end
    end
  end
end
