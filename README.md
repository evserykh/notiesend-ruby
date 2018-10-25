# Notisend-Ruby [![Build Status](https://travis-ci.org/evserykh/notiesend-ruby.svg?branch=master)](https://travis-ci.org/evserykh/notiesend-ruby)

This is the NotiSend Ruby Library. This library contains methods for easily interacting with the NotiSend API. Below are examples to get you started.

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
