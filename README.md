[![Gem Version](https://badge.fury.io/rb/conflisp.svg)](https://rubygems.org/gems/conflisp)

# Conflisp

A tool for buliding JSON-serializable lisps.

Sometimes you need to make something configurable at the database level, but
you don't want your application to have to support all possible variations of
that configuration.

You can also use Conflisp as a sort of JSON template language, à la
[Jsonnet](https://jsonnet.org/).

## Installation

### RubyGems

```bash
gem install conflisp
```

### Bundler

```ruby
gem 'conflisp'
```

## Usage

1.  Define your functions

    ```ruby
    MyLang = Conflisp::Language.define do
      fn :add, ->(a, b) { a + b }
      fn :subtract, ->(a, b) { a - b }
    end
    ```

2.  Use it

    ```ruby
    > MyLang.evaluate(['add', 2, ['subtract', 3, 1]])
    => 4
    ```

You can pass in variables into the evaluator and you will have access to them
in your expressions:

```ruby
> MyLang.evaluate(['add', 2, ['global', 'foo']], globals: { 'foo' => 3 })
=> 5
```

Normally you would store the expressions in a database and then evaluate them
when you need to:

```ruby
> myfoo = MyFoo.find(123)
> configuration = MyLang.evaluate(myfoo.config, globals: { 'current_time' => Time.now.utc })
```

Your functions can also refer to other functions using the `resolve` method:

```ruby
MyLang = Conflisp::Language.define do
  fn :add, ->(a, b) { a + b }

  fn :add_twice, ->(a, b) do
    resolve([
      'add',
      ['add', a, b],
      ['add', a, b]
    ])
  end
end
```

Conflisp only provides one built-in function (`global`). We don't want to be
opinionated on the ordering of the arguments to your functions (think `lodash`
vs. `lodash/fp`), so it is up to the application developer to implement all of
their functions.

You can also `extend` your languages to add new functions:

```ruby
BaseLang = Conflisp::Language.define do
  fn :add, ->(a, b) { a + b }
end

# NewLang will also have access to the `add` method.
NewLang = BaseLang.extend do
  fn :foo, ->() do
    # ...
  end
end
```

## Example language

```ruby
MyLang = Conflisp::Language.define do
  # Without this we wouldn't be able to express arrays
  fn :list, ->(*values) do
    values
  end

  fn :'==', ->(left, right) do
    left == right
  end

  fn :'!=', ->(left, right) do
    left != right
  end

  # Boolean

  fn :and, ->(*values) do
    raise ArgumentError, 'and requires at least 2 arguments' if values.size < 2

    values.reduce do |prev, value|
      prev && value
    end
  end

  fn :or, ->(*values) do
    raise ArgumentError, 'or requires at least 2 arguments' if values.size < 2

    values.reduce do |prev, value|
      prev || value
    end
  end

  # Mathematics

  fn :'<=', ->(left, right) do
    left <= right
  end

  fn :'>=', ->(left, right) do
    left >= right
  end

  # Collections

  fn :dig, ->(collection, *paths) do
    collection.dig(*paths)
  end

  # Special

  # This just a wrapper that gives us access to some config passed in through globals
  fn :config, ->(*keys) do
    resolve(['global', 'config']).dig(*keys)
  end
end
```

Then you could run a complex expression like this:

```ruby
> MyLang.evalute(
    [
      'join',
      ' ',
      [
        'or',
        ['and', ['>=', ['config', 'current_hour'], 19], 'Good evening'],
        ['and', ['>=', ['config', 'current_hour'], 13], 'Howdy'],
        ['and', ['>=', ['config', 'current_hour'], 11], 'Happy noon'],
        ['and', ['>=', ['config', 'current_hour'], 9], "G'day"],
        'Hello'
      ],
      ['config', 'user', 'name']
    ]
    globals: {
      'config' => {
        'current_hour' => Time.now.hour, # 14
        'user' => {
          'name' => 'Billy'
        }
      }
    }
  )
=> "Howdy Billy"
```

## Errors

When evaluating Conflisp expressions, there are two types of errors that can be
raised:

-   `Conflisp::MethodMissing` - raised if a method isn't defined in the language
-   `Conflisp::RuntimeError` - raised if there was an error during evaluation

## License

MIT License

Copyright © 2020 [Everwise](https://github.com/everwise)
