# Enhances the Twilio Ruby gem with an object-oriented approach.
module Twi
  # The representation of a medium (image) attached to a message.
  class Medium < Resource
    # @return [String] unique identifier
    def id = @params['Sid']

    # @return [Boolean] whether the medium has the content type of an image.
    def image? = content_type.match? %r{^image/}

    # @return [String] the content type
    def content_type = @params['ContentType']

    # @return [String] a URL where the image can be accessed at least for a few minutes.
    def url
      uri = URI service_url
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth Twi.lio.sid, Twi.lio.secret
      response = http.request(request)

      JSON(response.body).dig 'links', 'content_direct_temporary'
    end

  private

    def service_url
      "https://mcs.us1.twilio.com/v1/Services/#{Twi.lio.conversation_service_sid}/Media/#{id}"
    end
  end
end
