# Nokogiri::Cache

Add fragment caching when using `Nokogiri::XML::Builder` to build XML files in a Rails application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nokogiri-cache'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nokogiri-cache

## Usage

```ruby
Nokogiri::XML::Builder.new do |xml|
  xml.cache 'cache_key' do |xml|
    xml....
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dvandersluis/nokogiri-cache.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

