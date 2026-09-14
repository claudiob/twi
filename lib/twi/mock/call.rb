module Twi
  class Mock::Call < Call
    # @return [String] unique identifier
    def id = @params[:id]

    # @return [String] call status
    def status = @params[:status]

    # Records the call rather than placing it, and answers whatever the suite arranged.
    def create
      Twi.mock.calls << @params.slice(:sender, :recipient, :url, :status_callback)

      if error = Twi.mock.call_error
        Twi.mock.call_error = nil
        raise Error, error
      elsif Twi.mock.call
        @params[:id] = Twi.mock.call[:id]
        @params[:status] = Twi.mock.call[:status]
      else
        @params[:id] = "CA#{rand}"
        @params[:status] = 'queued'
      end
    end
  end
end
