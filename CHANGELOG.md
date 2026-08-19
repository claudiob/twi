## [0.7.0] - 2026-08-19

- [New] Add Twi.reset_mock, to stop a mocked answer outliving the test that arranged it
- [Fix] Answer an unarranged Twi::Mock::Conversation#create_with, as Message#create does

## [0.6.0] - 2026-07-27

- [Fix] Remove proxy_address from conversation participant

## [0.5.0] - 2026-07-27

- [New] Add Twi::Delivery#sender

## [0.4.0] - 2026-06-15

- [Fix] Include proxy_address in conversation participant

## [0.3.9] - 2026-06-08

- [Fix] Make Twi::Mock::Message.id not null

## [0.3.8] - 2026-06-02

- [Fix] Make Twi::Message.id not null

## [0.3.7] - 2026-06-01

- [Fix] Expose Twi::Mock::Message#sid

## [0.3.6] - 2026-06-01

- [Fix] Expose Twi::Conversation#id and #status

## [0.3.5] - 2026-06-01

- [Fix] Ignore 404 on conversation.delete

## [0.3.4] - 2026-06-01

- [Fix] Fix params of Twi::Error

## [0.3.3] - 2026-06-01

- [Fix] Use newer console URL for Twi::Conversation.url

## [0.3.2] - 2026-06-01

- [New] Add Twi::Message.url_for, Twi::Delivery.url_for, Twi::Delivery.unsubscribed?

## [0.3.1] - 2026-06-01

- [New] Raise Twi::Error, not Twilio::REST::RestError

## [0.3.0] - 2026-05-27

- [New] Add Twi::Message#create
- [New] Add Twi::Conversation#upload
- [New] Add Twi.event, Twi.mock.medium
- [New] Add Twi.conversation, Twi.mock.conversation, Twi.mock.conversation_error
- [New] Add Twi::Event.params_for
- [New] Add Twi.create_phone, Twi.mock.phone, Twi.mock.phone_error
- [New] Add Twi::Phone

## [0.2.0] - 2026-05-25

- [New] Twi::Delivery as a wrapper for direct message deliveries
- [New] Twi::Message as a wrapper for incoming direct messages
