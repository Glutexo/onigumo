module GalleryDownloader
  module FanartPikachuCz
    class PictureUri
      def initialize(uri)
        @uri = URI(uri)
      end

      def picture_id
        query = Hash[URI.decode_www_form(@uri.query)]
        query['picture'].to_i
      end
    end

    class ArtistUri
      def initialize(uri)
        @uri = URI(uri)
      end

      def artist_id
        query = Hash[URI.decode_www_form(@uri.query)]
        query['artist'].to_i
      end
    end

    class AllPicturesOrd
      def initialize(text)
        @text = text
      end

      def ord
        match = /^#(\d+)$/.match(@text)
        match[1].to_i
      end
    end

    class AllPicturesArtistName
      def initialize(text)
        @text = text
      end

      def name
        match = /^(.+):$/.match(@text)
        match[1]
      end
    end

    class AllPicturesDate
      def initialize(text)
        @text = text
      end

      def date
        match = /^.{2}  (\d{2}). (\d{2}). (\d{4})$/.match(@text)
        Date.new(match[3].to_i, match[2].to_i, match[1].to_i)
      end
    end
  end
end
