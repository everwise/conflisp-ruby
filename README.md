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
    MyLang = Conflisp.define do
      fn :add, ->(a, b) { a + b }
      fn :subtract, ->(a, b) { a - b }
    end
    ```

2.  Use it

    ```ruby
    > MyLang.evaluate(['add', 2, ['subtract', 3, 1]])
    => 3
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
MyLang = Conflisp.define do
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
BaseLang = Conflisp.define do
  fn :add, ->(a, b) { a + b }
end

# NewLang will also have access to the `add` method.
NewLang = BaseLang.extend do
  fn :foo, ->() do
    # ...
  end
end
```

## License

MIT License

Copyright © 2019 [Everwise](https://github.com/everwise)
