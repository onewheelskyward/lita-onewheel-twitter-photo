require 'nokogiri'
require 'rest-client'

module Lita
  module Handlers
    class OnewheelTwitterPhoto < Handler
      route /(http.*twitter.com\/.*\/status\/\d+)/i, :get_twitter_photo

      def get_twitter_photo(response)
        uri = response.matches[0][0]
        doc = RestClient.get uri
        noko_doc = Nokogiri::HTML doc
        noko_doc.xpath('//meta').each do |meta|
          attrs = meta.attributes
          if attrs['property'].to_s == 'og:image'
            image = attrs['content'].to_s
            if /media/.match image
              Lita.logger.debug "Twitter image response: " + image.sub(/:large/, '')
              response.reply image.sub /:large/, ''
            end
          end
        end
      end

      Lita.register_handler(self)
    end
  end
end
