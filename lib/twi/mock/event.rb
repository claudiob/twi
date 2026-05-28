module Twi
  class Mock::Event < Event
  private
    def medium_for(params) = Mock::Medium.new params
  end
end
