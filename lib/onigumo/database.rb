require('sequel')
require('sqlite3')

module Onigumo
  class Database
    class << self
      def connect(base_path)
        db_path = File.join(base_path, "database.db")
        db_exists = File.exists?(db_path)
        Sequel.connect("sqlite://#{db_path}") do |db|
          init_schema(db) unless db_exists
          yield db
        end
      end
      
      private
      def init_schema(db)
        db.create_table(:downloads) do
          primary_key :id
          String :url
          Integer :downloaded
        end
      end
    end
  end
end
