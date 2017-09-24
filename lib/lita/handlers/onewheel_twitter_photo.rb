require 'nokogiri'
require 'rest-client'

module Lita
  module Handlers
    class OnewheelTwitterPhoto < Handler
      config :room, required: true

      route /(http.*twitter.com\/.*\/status\/\d+)/i, :get_twitter_title

      def get_twitter_photo(response)
        uri = response.matches[0][0]
        doc = RestClient.get uri
        noko_doc = Nokogiri::HTML doc
        noko_doc.xpath('//meta').each do |meta|
          attrs = meta.attributes
          if attrs['property'].to_s == 'og:image'
            image = attrs['content'].to_s
            if /media/.match image
              Lita.logger.debug 'Twitter image response: ' + image.sub(/:large/, '')
              response.reply image.sub /:large/, ''
            end
          end
        end
      end

      def get_twitter_title(response)
        if response.message.source.room == config.room
          uri = response.matches[0][0]
          doc = RestClient.get uri
          noko_doc = Nokogiri::HTML doc
          title = noko_doc.xpath('//title').text.to_s
          Lita.logger.debug title
          response.reply title
          get_twitter_photo(response)
        end
      end

      Lita.register_handler(self)
    end
  end
end
