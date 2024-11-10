# Fractional Indexer

[![codecov](https://codecov.io/gh/kazu-2020/fractional_indexer/graph/badge.svg?token=OCCYE4EKT1)](https://codecov.io/gh/kazu-2020/fractional_indexer)
[![test](https://github.com/kazu-2020/fractional_indexer/actions/workflows/ruby.yml/badge.svg?branch=main&event=push)](https://github.com/kazu-2020/fractional_indexer/actions/workflows/ruby.yml)

> efficient data insertion and sorting through fractional indexing

This gem is designed to achieve "[Realtime editing of ordered sequences](https://www.figma.com/blog/realtime-editing-of-ordered-sequences/#fractional-indexing)" as featured in a Figma blog post.

Specifically, it implements Fractional Indexing as a means of managing order, realized through strings. By managing indexes as strings, it significantly delays the occurrence of index duplication that can arise when implementing Fractional Indexing with floating-point numbers. Additionally, using strings allows for the representation of a much larger range of numbers in a single digit compared to decimal numbers (by default, a single digit is represented in base-62).

This gem was implemented based on the excellent article "[Implementing Fractional Indexing.](https://observablehq.com/@dgreensp/implementing-fractional-indexing)" I would like to express my gratitude to David Greenspan, the author of the article.

> [!TIP]
> I developed the gem `nabikae` integrated with Active Record, allowing you to easily incorporate Fractional Indexing into your product🎉
> https://github.com/kazu-2020/narabikae

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fractional_indexer'
```

And then execute:

```sh
bundle
```

Or install it yourself as:

```sh
gem install fractional_indexer
```

## Usage

### Generate Order key

To generate an order key, use the `FractionalIndexer.generate_key` method.  
This method can take two arguments: prev_key and next_key, both of which can be either nil or a string (excluding empty strings).

The characters that can be used in the strings are available for review in `FractionalIndexer.configuration.digits`.

```ruby
require 'fractional_indexer'

# create first order key
FractionalIndexer.generate_key
# => "a0"

# increment
FractionalIndexer.generate_key(prev_key: 'a0')
# => "a1"

# decrement
FractionalIndexer.generate_key(next_key: 'a0')
# => "Zz"

# between prev_key and next_key
FractionalIndexer.generate_key(prev_key: 'a0', next_key: 'a2')
# => "a1"

# prev_key should be less than next_key
FractionalIndexer.generate_key(prev_key: 'a2', next_key: 'a1')
# => error
FractionalIndexer.generate_key(prev_key: 'a1', next_key: 'a1')
# => error
```

### Generate Multiple Order keys

To generate multiple order keys, use the `FractionalIndexer.generate_keys` method.

```ruby
require 'fractional_indexer'

# generate n order keys that sequentially follow a given prev_key.
FractionalIndexer.generate_keys(prev_key: "b11", count: 5)
# => ["b12", "b13", "b14", "b15", "b16"]

# generate n order keys that sequentially precede a given next_key.
FractionalIndexer.generate_keys(next_key: "b11", count: 5)
# => ["b0w", "b0x", "b0y", "b0z", "b10"]

# generate n order keys between the given prev_key and next_key.
FractionalIndexer.generate_keys(prev_key: "b10", next_key: "b11", count: 5)
# => ["b108", "b10G", "b10V", "b10d", "b10l"]
```

## Configure

### base

You can set the base (number system) used to represent each digit.  
The possible values are :base_10, :base_62, and :base_94. (The default is :base_62)

Note: base_10 is primarily intended for operational verification and debugging purposes.

```ruby
require 'fractional_indexer'

FractionalIndexer.configure do |config|
  config.base = :base_10
end
FractionalIndexer.configuration.digits.join
# => "0123456789"

FractionalIndexer.configure do |config|
  config.base = :base_62
end
FractionalIndexer.configuration.digits.join
# => "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

FractionalIndexer.configure do |config|
  config.base = :base_94
end
FractionalIndexer.configuration.digits.join
# => "!\"\#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
```

## Order key

This section explains the structure of the string that represents an Order Key.  
An Order Key string is broadly divided into two parts: the integer part and the fractional part.

Note: For ease of understanding, the explanation from here on will be based on the decimal system ('0' ~ '9')

### Integer Part

The integer part of the Order Key begins with a `mandatory prefix` that indicates the number of digits. This prefix is represented by one of the letters A to Z or a to z.  
a is 1 digit, b is 2 digits, c is 3 digits ...... and z represents 26 digits.  
The number of characters following the prefix must match the number of digits indicated by the prefix.  
For example, if the prefix is a, a valid key could be 'a8', and if the prefix is c, a valid key could be 'c135'.

```ruby
'a9'    # Valid
'b10'   # Valid
'b9'    # Invalid (The prefix 'b' requires two digits)
'c123'  # Valid
'c12'   # Invalid (The prefix 'c' requires three digits)
```

Additionally, leveraging the characteristic that uppercase letters have a lower ASCII value than lowercase letters, a to z represent positive integers, while A to Z represent negative integers.

### Fractional Part

The Fractional Part refers to the portion of the string that follows the Integer Part, excluding the Integer Part itself.

```ruby
'a3012'
# 'a3' : Integer Part
# '012': Fractional Part
```

The Fractional Part cannot end with the first character of the base being used (e.g., '0' in base_10). This rule mirrors the mathematical principle that, for example, 0.3 and 0.30 represent the same value.

```ruby
'a32'  # Valid
'a320' # Invalid (The Fractional Part cannot end with '0' in base_10)
```

This section clarifies the concept and rules regarding the Fractional Part of an Order Key, with examples to illustrate what constitutes a valid or invalid Fractional Part.

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/kazu-2020/fractional_indexer>.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
