module Pipestalk
  module Connection
    def pipes
      @_pipes ||= {}
    end

    def filters
      @_filters ||= {}
    end

    def pipe(name)
      pipes[name] ||= Pipe.new(name, connection)
    end

    def filter(name, handler=nil, &block)
      if (handler ||= block).nil?
        filters[name]
      else
        handler = handler.new if handler.respond_to?(:new)
        filters[name] = Filter.new(name, connection, &handler)
      end
    end

    def connect(mapping)
      mapping.each_pair do |from, to|
        pipe(from).connect(*([to].flatten.compact.map { |n| pipe(n) }))
      end
    end

    def process!
      connection.jobs.process!
    end
  end
end
