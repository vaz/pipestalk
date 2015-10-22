module Pipestalk
  class Filter
    IDENTITY = ->(x) { x }

    attr_reader :name, :connection

    def initialize(name, connection=nil, &block)
      @name = name
      @connection = connection || Pipestalk.connection

      @in  = Pipe.new("#{name}.in")
      @out = Pipe.new("#{name}.out")

      @in.connect(@out, &block)
      @out.connect(nil)
    end

  end
end
