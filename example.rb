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
