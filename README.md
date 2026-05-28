# The enhanced Twilio API Ruby client

## Available methods

### Twi::Message

When receiving an incoming direct message via webhook:

```ruby
message = Twi::Message.new params
message.id # => 'SM083e290bef7794c407f14e22a891aa6d'
message.content # => 'Hello world'
message.sender # => '8009007000'
message.recipient # => '8008008000'
message.wallflower # nil
message.opt_in? # false
message.opt_out? # false
message.image_urls # => ['https://example.com/image.png']
```

When building a Twilio-like webhook payload:

```ruby
Twi::Message.params_for id: 'SM12', content: 'Hello', sender: '8009007000', recipient: '8008008000'
 # => { MessageSid: 'SM12', Body: 'Hello',From: '+18009007000', To: '+18008008000' } 
```

### Twi::Delivery

When receiving a delivery notification via webhook:

```ruby
delivery = Twi::Delivery.new params
delivery.id # => 'SM083e290bef7794c407f14e22a891aa6d'
delivery.status # => 'draft'
delivery.code # => '30006'
```

When building a Twilio-like webhook payload:

```ruby
Twi::Delivery.params_for id: 'SM12', status: 'sent'
 # => { SmsSid: 'SM12', MessgeStatus: 'sent', ErrorCode: nil } 
```

### Twi::Event

When receiving events about a conversation:

```ruby
event = Twi::Event.new params
event.id # => 'SM083e290bef7794c407f14e22a891aa6d'
event.conversation_id # => 'CH123'
event.target # => :participant
event.participant # => #<Participant id: 'SH12', phone: '9008009000', identity: nil>
```

### Twi::Phone

To create an incoming phone number:

```ruby
phone = Twi.create_phone area_code:, friendly_name:
phone.id # => 'SM083e290bef7794c407f14e65a891aa6d'
phone.number # => '5556667777'
```

## Available mocks

Use these methods to mock request to Twilio when testing an app:

### Credentials

Mock an error when creating an incoming phone number:

```ruby
Jbr.mock.phone_error = { code: '21452' }
```

Mock successfully creating an incoming phone number:

```ruby
Jbr.mock.phone = { id: 'SM083e290bef7794c407f14e65a891aa6d', number: '8009005000' }
```


## To Do

4. have an interface to send and receive SMS with photos
8. have an error code URL for each error code and a sid_url
9. Declare some phones like Twilio.homeowner_phone or Twilio.numbers[:ddd] and a default Twilio.number and similar Twilio.messaging_service
10. a way to reopen closed conversations
11. a way to create conversations
12. and upload pictures in a conversation
13. x_twilio_webhook_enabled: true

