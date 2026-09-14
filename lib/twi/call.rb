# Enhances the Twilio Ruby gem with an object-oriented approach.
module Twi
  # The representation of an outbound phone call.
  class Call < Resource
    # @return [String] unique identifier
    def id = @params['CallSid']

    # @return [String] call status, one of queued, ringing, in-progress, completed, busy,
    # no-answer, canceled, failed # TODO: make an enum
    def status = @params['CallStatus']

    # @return [String, nil] digits the callee pressed in answer to a Gather.
    def digits = @params['Digits']

    # @return [String] 10-digit phone number placing the call.
    def sender = remove_prefix_from @params['From']

    # @return [String] 10-digit phone number being called.
    def recipient = remove_prefix_from @params['To']

    # Places the call, asking Twilio to fetch its instructions from +url+.
    def create
      call = api_client.calls.create from: "+1#{@params[:sender]}", to: "+1#{@params[:recipient]}",
        url: @params[:url], method: 'GET', status_callback: @params[:status_callback]

      @params = { 'CallSid' => call.sid, 'CallStatus' => call.status }
    rescue Twilio::REST::RestError => error
      raise Error, code: error.code, message: error.error_message
    end

    # @return [Hash] the shape of the payload send by Twilio to the callback URL.
    def self.params_for(id:, status:, digits: nil)
      { CallSid: id, CallStatus: status, Digits: digits }.compact
    end
  end
end
