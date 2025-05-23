## Debugging Action::Mailbox

If you receive a message on the server and get errors, you can look this up from the database, and get the raw source of the email:

```ruby
mail = ActionMailbox::InboundEmail.find(7025)
puts mail.mail.raw_source
```

You can then take this source, and create a fixture in your tests using the copied source, to help debug and fix your code. Places the contents into `/spec/fixtures/files/email_without_subject`.

```ruby
# Inside your spec:
receive_inbound_email_from_fixture("email_without_subject")
```
