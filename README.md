# Rspec::DescriptionConsistency

One of the basic RSpec [best practices](https://www.betterspecs.org) advises using specific describe block descriptions if it describes a specific method:

```ruby
# star.rb

class Star
  def self.build(*args, **kwargs)
    '?'
  end

  def shape
    '?'
  end
end
```

```ruby
# star_spec.rb

RSpec.describe Star do
  describe '.build' do
    '?'
  end

  describe '#shape' do
    '?'
  end
end
```

If your team follows this convention, you might quickly encounter inconsistencies as your system evolves: you have to make sure that renaming or moving a method is done with appropriate modification to the `describe` block description.

This gem enforces consistency by checking descriptions against the described object methods at runtime.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add rspec-description_consistency

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install rspec-description_consistency

## Usage

Add `RSpec::DescriptionConsistency.bind(config)` to your `spec_helper.rb`:

```ruby
RSpec.configure do |config|
  RSpec::DescriptionConsistency.bind config
end
```

You can provide additional configuration via `RSpec::DescriptionConsistency.configure`:

```ruby
RSpec::DescriptionConsistency.configure do |config|
  # Set to `false` to disable (default: `true`).
  config.enabled = true

  # Exit with specific code if any inconsistencies were detected (default: `0`).
  # If set to `0`, RSpec's exit code will be preserved.
  config.exit_code = 1

  # Custom output stream (default: `Rspec.configuration.output_stream`).
  config.output_stream = 'tmp/rspec-description_consistency.txt'
end
```

By default, descriptions are matched against public and protected methods. If you want to indicate that a specific `describe` refers to a private method you can add `private` flag:

```ruby
describe '#some_private_method', :private do # or `private: true`
  '?'
end
```

You can disable consistency verification completely by specifying `description_consistency: false` for `describe` block:

```ruby
describe '.this_method_will_not_be_checked', description_consistency: false do
  '?'
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/viralpraxis/rspec-description_consistency. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/viralpraxis/rspec-description_consistency/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rspec::DescriptionConsistency project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/viralpraxis/rspec-description_consistency/blob/main/CODE_OF_CONDUCT.md).
