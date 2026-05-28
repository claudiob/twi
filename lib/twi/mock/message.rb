module Twi
  class Mock::Message < Resource
    # @return [String] unique identifier
    def id = @params[:id]
  end
end
