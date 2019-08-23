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
      @conn[:downloads] << {url: url.to_s, complete: 0}
    end
    
    def add_action(spider, meth)
      unless spider_method_exist?(spider, meth)
        raise ArgumentError.new("Invalid method #{spider}##{meth}")
      end
      @conn[:actions] << {spider: spider.to_s, method: meth.to_s, complete: 0}
    end
    
    private
    def init_schema
      @conn.create_table(:actions) do
        primary_key(:id)
        String(:spider, null: false)
        String(:method, null: false)
        Integer(:complete, null: false)  # boolean
      end

      @conn.create_table(:downloads) do
        primary_key(:id)
        String(:url, null: false)
        Integer(:complete, null: false)  # boolean
      end

      @conn.create_table(:parses) do
        primary_key(:id)
        foreign_key(:download, :downloads)
        String(:spider, null: false)
        String(:method, null: false)
        Integer(:complete, null: false)  # boolean
      end
    end
    
    def spider_method_exist?(spider, meth)
      begin
        cls = Object.const_get("Onigumo::Spiders::#{spider}")
      rescue NameError
        return false
      end
      cls.methods.include?(meth.to_sym)
    end
  end
end
