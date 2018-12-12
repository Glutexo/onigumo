require_relative('helpers')
require_relative(File.join('..', '..', 'result'))

module GalleryDownloader
  module FanartPikachuCz
    BASE_URI = URI('http://fanart.pikachu.cz/')

    class AllPicturesPageMeta
      def initialize(data)
        @text = data[:text]
      end
    end

    class AllPicturesPictureMeta
      def initialize(data)
        @ord = data[:ord]
        @name = data[:name]
        @fullview_count = data[:fullview_count]
        @description = data[:description]
        @artist_name = data[:artist_name]
        @artist_id = data[:artist_id]
        @upload_date = data[:upload_date]
      end
    end

    class AllPictures
      BASE_URI = GalleryDownloader::FanartPikachuCz::BASE_URI.clone
      BASE_URI.path = '/content/pictures.php'
      BASE_URI.query = URI.encode_www_form('odtp' => '1')

      def initialize(agent, from = 0, per_page = 10)
        @agent = agent
        @from = from
        @per_page = per_page
      end

      def uri
        base_query = Hash[URI.decode_www_form(BASE_URI.query)]
        query = base_query.merge('ppp' => @per_page, 'od' => @from)

        u = BASE_URI.clone
        u.query = URI.encode_www_form(query)
        u
      end

      def pages
        body = @agent.get('odtp=1&ppp=1&od=0')
        body.match.each do |page_link|
          yield Result.new(scraper: AllPictures(@agent, page_link.number),
                           meta: AllPicturesPageMeta(page_link.text))
        end
      end

      def pictures
        page = @agent.get(uri)
        thumbinfos = page / 'div.thumbinfo'
        thumbinfos.each do |thumbinfo|
          name_link = (thumbinfo / 'div.name a').first
          picture_id = FanartPikachuCz.picture_id_from_uri(name_link['href'])
          picture = Picture.new(@agent, picture_id)

          num_node = (thumbinfo / 'div.num').first
          ord = FanartPikachuCz.ord_from_num(num_node.text)

          fullview_count_node =
            (thumbinfo / 'div.stats span.fullviewcount span.number').first
          fullview_count =
            if fullview_count_node.nil?
              nil
            else
              fullview_count_node.text.to_i
            end

          description_node = (thumbinfo / 'div.desc').first
          description = description_node.nil? ? nil : description_node.text

          artist_link = (thumbinfo / 'div.artist a').first
          artist_id = FanartPikachuCz.artist_id_from_uri(artist_link['href'])

          artist_name =
            FanartPikachuCz.artist_name_from_artist(artist_link.text)

          datetime_node = (thumbinfo / 'div.datetime').first
          upload_date = FanartPikachuCz.date_from_datetime(datetime_node.text)

          meta = AllPicturesPictureMeta.new(
            ord: ord.ord,
            name: name_link.text,
            fullview_count: fullview_count,
            description: description,
            artist_name: artist_name,
            artist_id: artist_id,
            upload_date: upload_date
          )

          yield Result.new(scraper: picture, meta: meta)
        end
      end
    end

    class Picture
      def initialize(agent, picture_id)
        @agent = agent
        @picture_id = picture_id
      end
    end
  end
end