# Notisend-Ruby [![Build Status](https://travis-ci.org/evserykh/notiesend-ruby.svg?branch=master)](https://travis-ci.org/evserykh/notiesend-ruby) [![Gem Version](https://badge.fury.io/rb/notisend-ruby.svg)](https://badge.fury.io/rb/notisend-ruby)

This is the NotiSend Ruby Library. This library contains methods for easily interacting with the [NotiSend API](https://notisend.ru/dev/email/api/). Below are examples to get you started.

## Installation

Run in console:

```sh
gem install notisend-ruby
```

or add to Gemfile:

```ruby
gem 'notisend-ruby'
```

## Configuration

First, you need to set up you api token. You can do that by using the environment varialble `NOTISEND_API_TOKEN` or set it in code:

```ruby
require 'notisend'

Notisend.configure do |config|
  config.api_token = 'my-secret-token'
end
```

## Messages

### Send a message

```ruby
message = Notisend::Message.deliver(
  from_email: 'sender@mail.com',
  to: 'recipient@mail.com',
  subject: 'Hello',
  html: '<h1>World</h1>',
  text: 'World'
)
message # => #<Notisend::Message id=1, payment="subscriber", from_email="sender@mail.com", from_name=nil, to="recipient@mail.com", subject="Hello", text="World", html="<h1>World</h1>", attachments=[], status="queued", events={}>
```

### Get message's info

```ruby
message = Notisend::Message.get(id: 1)
message # => #<Notisend::Message id=1, payment="subscriber", from_email="sender@mail.com", from_name=nil, to="recipient@mail.com", subject="Hello", text="World", html="<h1>World</h1>", attachments=[], status="queued", events={}>
```

### Send a message using a template

```ruby
message = Notisend::Message.deliver_template(template_id: 1, to: 'recipient@mail.com')
message # => #<Notisend::Message id=1, payment="subscriber", from_email=nil, from_name=nil, to="recipient_mail.com", subject=nil, text=nil, html=nil, attachments=[], status="queued", events={}>
```

## Lists

### Get the lists

```ruby
result = Notisend::List.get_all # get all lists paginated
result = Notisend::List.get_all(params: { page_number: 1, page_size: 1 }) # or get the specific page
result # =>  #<Notisend::Collection total_count=12, total_pages=12, page_number=1, page_size=1, collection=[#<Notisend::List id=1, title="My List">]>
result.collection.first # => #<Notisend::List id=1, title="My List">
```

### Create a list

```ruby
list = Notisend::List.create(title: 'New List')
list # => #<Notisend::List id=2, title="New List">
```

### Get list's info

```ruby
list = Notisend::List.get(id: 2)
list # => #<Notisend::List id=2, title="New List">
```

## Parameters

### Get list's parameters

```ruby
result = Notisend::Parameter.get_all(list_id: 1)
result = Notisend::Parameter.get_all(list_id: 1, params: { page_number: 1, page_size: 1 })
result # => #<Notisend::Collection total_count=1, total_pages=1, page_number=1, page_size=1, collection=[#<Notisend::Parameter id=1, title="Full Name", kind="string", list_id=1>]>
result.collection.first # => #<Notisend::Parameter id=1, title="Full Name", kind="string", list_id=1>
```

### Create a list's parameter

```ruby
parameter = Notisend::Parameter.create(title: 'Age', kind: 'numeric', list_id: 1)
parameter # => #<Notisend::Parameter id=2, title="Age", kind="numeric", list_id=1>
```

## Recipients

### Get list's recipients

```ruby
result = Notisend::Recipient.get_all(list_id: 1)
result = Notisend::Recipient.get_all(list_id: 1, params: { page_number: 1, page_size: 1 })
result # => #<Notisend::Collection total_count=3, total_pages=3, page_number=1, page_size=1, collection=[#<Notisend::Recipient id=1, email="recipient@mail.com", list_id=1, confirmed=true, values=[]>]>
result.collection.first # => #<Notisend::Recipient id=1, email="recipient@mail.com", list_id=1, confirmed=true, values=[]>
```

### Create a recipient

```ruby
recipient = Notisend::Recipient.create(email: 'recipient@mail.com', list_id: 1) # create a recipient without values
recipient = Notisend::Recipient.create(email: 'recipient1@mail.com', list_id: 1, values: [{parameter_id: 1, value: "foobar"}])
recipient # => #<Notisend::Recipient id=1, email="recipient@mail.com", list_id=1, confirmed=true, values=[{"value"=>"foobar", "kind"=>"string", "parameter_id"=>1}]>
```

### Update a recipient

```ruby
recipient = Notisend::Recipient.update(id: 1, list_id: 1, email: 'new.recipient@mail.com')
recipient = Notisend::Recipient.update(id: 1, list_id: 1, values: [{parameter_id: 1, value: "barbaz"}])
recipient # => #<Notisend::Recipient id=1, email="new.Recipient@mail.com", list_id=1, confirmed=true, values=[{"value"=>"barbaz", "kind"=>"string", "parameter_id"=>1}]>
```

### Import a batch of recipients

```ruby
result = Notisend::Recipient.import(
  list_id: 1,
  recipients: [
    { email: 'recipient@mail.com' },
    { email: 'recipient1@mail.com', values: { [{ parameter_id: 1, value: 'some value' }] } },
  ]
)
result # => #<Notisend::RecipientsImport id=1, status="queued">
```

### Delete a recipient

```ruby
Notisend::Recipient.delete(list_id: 1, id: 1) # => nil
```

## Contributing

1. Fork it
2. Create your feature branch
3. Test your feature and follow style guide (feel free to run `rake`, `rspec` and `rubocop`)
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request
