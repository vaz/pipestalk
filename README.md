# Pipestalk

Pipestalk is a thin layer over
[beaneater](https://github.com/beanstalkd/beaneater) that uses beanstalkd
queues to define I/O streams and data-processing filters and compose them
in a UNIX-y way, for simple inter-component messaging.

Pipestalk is still very alpha.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pipestalk'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pipestalk

## Usage

```ruby
require 'pipestalk'

Pipestalk.connection.configure do |c|
  c.namespace = 'example'
end

producer_out = Pipestalk.pipe("producer")
consumer_in = Pipestalk.pipe("consumer")
Pipestalk.filter("lowercase") { |data| data.downcase }

# connections can be forked--consumer will get both processed and
# unprocessed data:
Pipestalk.connect "producer" => ["lowercase.in", "consumer"],
                  "lowercase.out" => "consumer"

# connect to nil and pass a block to consume data from the pipeline:
consumer_in.connect(nil) do |data|
  puts data
end

produce = Thread.new do
  %w(THIS is SOME Example Data).each { |word| producer_out << word }
end

consume = Thread.new do
  Pipestalk.process! # blocks
end

produce.join
consume.join
```

Output:

```
$ bundle exec ruby example.rb
THIS
is
SOME
Example
Data
this
is
some
example
data
^Cexample.rb:30:in `join': Interrupt
	from example.rb:30:in `<main>'
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/pipestalk/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
