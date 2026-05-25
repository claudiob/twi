# The Twilio API Ruby client enhanced

## Available methods


### Twi::Message

When receiving an incoming direct message via webhook:

```ruby
message = Twi::Message.from params
message.sid # => 'SM083e290bef7794c407f14e22a891aa6d'
message.sent_at # => 2026-05-23 12:40:12 UTC
message.content # => 'Hello world'
message.image_urls # => ['https://example.com/image.png']
message.sender # => '8009007000'
message.recipient # => '8008008000'
message.wallflower # nil
message.opt_in? # false
message.opt_out? # false
```


### Twi::Delivery

When receiving a delivery notification via webhook:

```ruby
delivery = Twi::Delivery.from params
delivery.sid # => 'SM083e290bef7794c407f14e22a891aa6d'
delivery.status # => 'draft'
delivery.code # => '30006'
```


twi = Twi.sign message:, secret:

twi.timestamp # => 1779489515999
twi.signature # => 46f5297a94d0050ba6039bfcb12d6e4c1f955e39b34f98cf2bd5f9720b34ac49
```

Verify a signed message:

```ruby
twi = Twi.new message:, secret:
twi.signed? signature:, timestamp: # true
```


### Things to do

#### 1. Rails engine for callback routes


What **types** of webhooks?

##### 1a. for direct message deliveries (POST /deliveries)

- [x] tell me the message sid, the new status (from an enum), the error code

##### 1b. for incoming direct messages (POST /messages)

- [ ] tell me the sender number without +1
- [ ] tell me if it's an OptIn or an OptOut
- [ ] tell me if there's other recipient (called `other` or `witness` or `wallflower`)
- [ ] TODO: replace *two* answers endpoints with one that accepts the recipient number to distinguish

##### 1c. for conversations (POST /conversations)

- [ ] after a conversation is created or updated, tell me the new status (should be `ready`)
- [ ] after a participant is added, give me the participant (sid, identity, and phone without +1)
- [ ] after a message is posted, tell me the participant and sid, body, media URLs of the message
- [ ] after a delivery, tell me the message sid, the new sttatus, and the error code

so there would be a Twi::Delivery object probably


what would a Twi gem do in principle?

1. have a Rails engine with the webhook URLs already set?
2. honor Opt in/out somehow
3. if an SMS has OtherRecipient0 then...
4. have an interface to send and receive SMS with photos
5. another webhook for conversations
6. another one to be notified of deliveries
7. Assistant > create a phone number
8. have an error code URL for each error code and a sid_url
9. Declare some phones like Twilio.homeowner_phone or Twilio.numbers[:ddd] and a default Twilio.number and similar Twilio.messaging_service
10. a way to reopen closed conversations
11. a way to create conversations
12. and upload pictures in a conversation
13. x_twilio_webhook_enabled: true
14. return SIDs so we can store them
15. Set up defaults likw Twi::Lio.sid
16. Twi.mock = true

what about an active record numbers table and a conversations table

