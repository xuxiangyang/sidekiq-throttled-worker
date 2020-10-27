# Sidekiq::Throttled::Worker

Sidekiq concurrency limit per worker in whole cluster,  inspired by [sidekiq-throttled](https://github.com/sensortower/sidekiq-throttled). This gem only support concurrency, and try to avoid use lua in redis to reduce redis CPU usage.

This gem was designed to limit concurrency for some sensitive resources, e.g., databases and http requests, without concurrency limit, sidekiq may crush this services. When some worker exceed concurrency limit, this gem may try to slow down sidekiq process. Concurrency limit should only be use to in extreme case, you should not use this gem to limit business logic

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sidekiq-throttled-worker'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install sidekiq-throttled-worker

## Usage

After Sidekiq `configure_server`，you should add next line in sidekiq initializer

```ruby
Sidekiq::ThrottledWorker.setup!
```


This gem add two options attr in `sidekiq_options` func：

* `concurrency` : limit concurrency with current worker in whole cluster. Default is  `nil` , which mean on limit
* `concurrency_ttl` : max worker run time, and worker may be block completely max for `concurrency_ttl` in  extreme case. Default is 900, in most cases, you do not need change this.

Here is an example worker

```ruby
class TestWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, concurrency: 2

  def perform
  end
end

```



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sidekiq-throttled-worker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/sidekiq-throttled-worker/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sidekiq::Throttled::Worker project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/sidekiq-throttled-worker/blob/master/CODE_OF_CONDUCT.md).
