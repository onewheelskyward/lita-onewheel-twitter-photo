require 'nokogiri'

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
            response.reply attrs['content'].to_s.sub /:large/, ''
          end
        end
      end

      Lita.register_handler(self)
    end
  end
end
