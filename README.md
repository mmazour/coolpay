# mmazour's Coolpay gem

This is an API wrapper for the [Coolpay API](https://coolpayapi.docs.apiary.io).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'coolpay', git: 'https://github.com/mmazour/coolpay'
```

And then execute:

    $ bundle


## Requirements

A Coolpay account and API key.

This gem was developed and tested under Ruby 2.6.2, but ought to run on earlier (stable, supported) versions of Ruby.

## Usage

First, configure Coolpay:

```ruby
$ bin/console
> Coolpay.api_url = 'https://your-coolpay-server.io/api'
> Coolpay.username = 'your-username'
> Coolpay.api_key = 'your-secret-key'
```

All requests require a session token obtained during login. Login is automatic (every request will log in if you are not already logged in), but if you want to check the validity of your credentials first, you can log in directly.

```ruby
> Coolpay.authorized?
=> false
> Coolpay.authorize
=> true
```

#### Recipients

Searching and listing recipients:

```ruby
> Coolpay::Recipient.find('Jake McFriend')
=> #<Coolpay::Recipient:0x00007fad1e8c7828 @id="6e7b4cea-5957-11e6-8b77-86f30ca893d3", @name="Jake McFriend">

> Coolpay::Recipient.list
=> [#<Coolpay::Recipient:0x00007fad1e4998c8 @id="6e7b4cea-5957-11e6-8b77-86f30ca893d3", @name="Jake McFriend">, #<Coolpay::Recipient:0x00007fad1e5924f0 @id="2a699718-142a-469e-8c1f-9b486b20bbbf", @name="Sandy McPal">]
```

Recipients are instances of `Coolpay::Recipient`, with immutable `id` and `name` properties.

To create a new recipient:

```ruby
> Coolpay::Recipient.create('D. Bestie')
=> #<Coolpay::Recipient:0x00007fad1e5e0268 @id="d6d1189c-d88f-4b28-b7d6-b1cf362cc9d3", @name="D. Bestie">
```

#### Payments

Making a payment requires the `id` of a `Recipient`, an amount, and a currency (using one of the standard abbreviations) 

```ruby
# Send some money to D. Bestie
> Coolpay::Payment.create(recipient: 'd6d1189c-d88f-4b28-b7d6-b1cf362cc9d3', amount: 17.50, currency: :gbp)
=> #<Coolpay::Payment:0x00007fad1e69f780 @id="7328f67b-4dd9-4148-a0e4-ff3280afda8f", @recipient_id="d6d1189c-d88f-4b28-b7d6-b1cf362cc9d3", @currency=:gbp, @amount=17.5, @string_amount="17.5", @status="processing">
```

Listing payments:

```ruby
> Coolpay::Payment.list
=> [#<Coolpay::Payment:0x00007fad1d8a2628 @id="7328f67b-4dd9-4148-a0e4-ff3280afda8f", @recipient_id="d6d1189c-d88f-4b28-b7d6-b1cf362cc9d3", @currency=:gbp, @amount=17.5, @string_amount="17.5", @status="paid">]
```

(Coolpay has no "find payment" API. If you need to find a specific payment, fetch the whole list and filter it.)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MmazourCoolpay project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mmazour/mmazour_coolpay/blob/master/CODE_OF_CONDUCT.md).
