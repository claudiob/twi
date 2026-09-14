require 'simplecov'
# No minimum_coverage: this suite covers what places a call, and the conversations, events
# and media the gem grew before it had any tests at all are still untested.
SimpleCov.start

require 'minitest/autorun'
require 'webmock/minitest'

ENV['TWILIO_SID'] = 'AC00000000000000000000000000000000'
ENV['TWILIO_SECRET'] = 'secret'

require_relative '../lib/twi'
