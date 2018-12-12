module GalleryDownloader
  module FanartPikachuCz
    def picture_id_from_uri(uri)
      u = URI(uri)
      query = Hash[URI.decode_www_form(u.query)]
      query['picture'].to_i
    end

    def artist_id_from_uri(uri)
      u = URI(uri)
      query = Hash[URI.decode_www_form(u.query)]
      query['artist'].to_i
    end

    def ord_from_num(text)
      match = /^#(\d+)$/.match(text)
      match[1].to_i
    end

    def artist_name_from_artist(text)
      match = /^(.+):$/.match(text)
      match[1]
    end

    def date_from_datetime(text)
      match = /^.{2}  (\d{2}). (\d{2}). (\d{4})$/.match(text)
      Date.new(match[3].to_i, match[2].to_i, match[1].to_i)
    end

    module_function(
      :picture_id_from_uri,
      :artist_id_from_uri,
      :ord_from_num,
      :artist_name_from_artist,
      :date_from_datetime
    )
  end
end
