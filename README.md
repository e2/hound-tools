# Hound::Tools

Tools and configuration to locally simulate HoundCi checks

## Installation

Add this line to your application's Gemfile:

```ruby
group :development do
  gem 'hound-tools', '~> 0.0', require: false
end
```

Run this to setup your config files so that Hound will produce the same results
as running Rubocop locally:

```bash
$ hound-tools init
```


## Usage

You can locally simulate a HoundCi check using:

```bash
$ hound-tools
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/hound-tools/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
