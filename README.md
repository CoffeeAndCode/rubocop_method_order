# Rubocop MethodOrder

Bring back order to your Ruby files by leveraging this [Rubocop][0] extension to
require methods be listed in alphabetical order in your code, grouped by scope
and context. Method order is evaluated by looking at a methods context
(ex: top-level method or inside a class/module) as well as the method's scope
(ex: public, private, protected, class method).

Special treatment is given to the `initialize` method and it is expected to
be listed as the first public method for `Module` and `Class` methods.

The extension also works with `rubocop --auto-correct`, though you may want to
only attempt corrections on code already committed to git just in case there
are any issues.

## Installation

RuboCopMethodOrder is [cryptographically signed][1]. To be sure the gem you install
hasn't been tampered with:

```
# Add my public key (if you haven’t already) as a trusted certificate
gem cert --add <(curl -Ls https://raw.github.com/CoffeeAndCode/rubocop_method_order/master/certs/coffeeandcode.pem)
```

Then, add this line to your application's Gemfile:

```ruby
gem 'rubocop_method_order'
```

And then execute:

    $ bundle --trust-policy MediumSecurity

Or install it yourself as:

    $ gem install rubocop_method_order -P MediumSecurity

The MediumSecurity trust profile will verify signed gems, but allow the
installation of unsigned dependencies. This is necessary because not all of
RuboCopMethodOrder's dependencies are signed, so we cannot use HighSecurity.

Lastly, you'll need to explicitly require the extension in your Rubocop config
like so:

```yaml
require:
  - rubocop_method_order

# the rest of your config...
```

## Usage

Here are a few desirable, already ordered examples and you can find more
examples in the [test/fixtures/](test/fixtures/) directory of this project.

```ruby
# In this example, `foo` should be listed after `bar` with both after the
# `initialize` method. If in the incorrect order, both methods will
# actually show a linter error with a message indicating if they should
# show 'before' or 'after' a comparision method. The private methods will
# also each show errors in relation to each other if in the opposite order.
class ExampleClass
  def initialize
  end

  def bar
  end

  def foo
  end

  private

  def another_method
  end

  def private_method
  end
end
```

```ruby
# This extension works on module methods as well.
module ExampleModule
  def self.example
  end

  # If included in a class, this method would be given special treatment so
  # we expect it listed first if present in the module.
  def initialize
  end

  def bar
  end

  def foo
  end
end
```

```ruby
# This extension will also work with plain-ol Ruby files with top level method
# definitions.
def bar
end

def foo
end
```

By default, this extension will examine all method definitions and class method
definitions found in the Ruby source. You can exclude specific methods by using
a Rubocop `disable comment` like:

```ruby
def my_method # rubocop:disable Style/MethodOrder
end

# rubocop:disable Style/MethodOrder
def another_excluded_method
end
# rubocop:enable Style/MethodOrder
```

You can also exclude entire files using the `Exclude` configuration:

```yaml
Style/MethodOrder:
  Exclude:
    - test/**/*_test.rb
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
run `rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

Make sure that the project has no errors when running `bundle exec rake` which
will run `rubocop` on the project source and `bundle exec rake test`.

To release a new version, update the version number in `lib/rubocop_method_order/version.rb`,
run `bin/build` and commit the checksum into git, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to [rubygems.org][2].

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/CoffeeAndCode/rubocop_method_order.

[0]: https://github.com/bbatsov/rubocop
[1]: http://guides.rubygems.org/security/
[2]: https://rubygems.org
