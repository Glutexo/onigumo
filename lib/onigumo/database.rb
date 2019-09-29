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
    
    def add_action(spider, meth)
      assert_spider_method_exist(spider, meth)
      add(:actions, spider_method_data(spider, meth))
    end

    def add_download(url)
      add(:downloads, url: url.to_s)
    end

    def add_parse(spider, meth, download)
      assert_spider_method_exist(spider, meth)
      data = spider_method_data(spider, meth).merge(download: download.to_i)
      add(:parses, data)
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
    
    def downloadable_urls
      @conn[:downloads].where(complete: 0).select(:id, :url).each do |row|
        yield row[:id], row[:url]
      end
    end
    
    def complete_action(id)
      complete(:actions, id)
    end
    
    def complete_download(id)
      complete(:downloads, id)
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
    
    def assert_spider_method_exist(spider, meth)
      unless Onigumo.spider_method_exist?(spider, meth)
        raise ArgumentError.new("Invalid method #{spider}##{meth}")
      end
    end
    
    def spider_method_data(spider, meth)
      {spider: spider.to_s, method: meth.to_s}
    end
    
    def add(table, custom_data)
      all_data = {complete: 0}.merge(custom_data)
      @conn[table].insert(all_data)
    end
    
    def complete(table, id)
      @conn[table].where(id: id).update(complete: 1)
    end
  end
end
