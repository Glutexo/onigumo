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
      unless Onigumo.spider_method_exist?(spider, meth)
        raise ArgumentError.new("Invalid method #{spider}##{meth}")
      end
      @conn[:actions] << {spider: spider.to_s, method: meth.to_s, complete: 0}
    end
    
    def runnable_actions
      @conn[:actions].left_join(:parses, id: :parse).where(
        Sequel[
          {Sequel[:actions][:complete] => 0}
        ].|(
          Sequel[:actions][:parse] => nil,
          Sequel[:parses][:complete] => 0
        )
      ).select(
        Sequel[:actions][:id],
        Sequel[:actions][:spider],
        Sequel[:actions][:method]
      ).each do |row|
        yield row[:id], row[:spider], row[:method]
      end
    end
    
    def complete_action(id)
      @conn[:actions].where(id: id).update(complete: 1)
    end
    
    private
    def init_schema
      @conn.create_table(:actions) do
        primary_key(:id)
        foreign_key(:parse, :parses)
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
        foreign_key(:download, :downloads, null: false)
        String(:spider, null: false)
        String(:method, null: false)
        Integer(:complete, null: false)  # boolean
      end
    end
  end
end
