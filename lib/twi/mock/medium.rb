module Twi
  class Mock::Medium < Medium
    # @return [String] a mock URL for the image.
    def url
      Twi.mock.medium[:url] if Twi.mock.medium
    end
  end
end
