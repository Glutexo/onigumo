require_relative('flies')

module Onigumo
  module FanartPikachuCz
    def all_pictures(agent)
      all_pictures = AllPictures.new(agent)
      all_pictures.pictures do |picture|
        yield picture.fly.uri
      end
    end

    module_function(:all_pictures)
  end
end
