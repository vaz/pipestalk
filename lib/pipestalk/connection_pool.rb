module Pipestalk
  class ConnectionPool
    delegate [:close, :connections, :jobs, :stats, :tubes,
              :transmit_to_all, :transmit_to_rand,
              :transmit_until_res] => :@pool

    include Connection

    attr_reader :configuration, :pipes

    def initialize(addresses=nil, options={})
      @pool = Beaneater::Pool.new(addresses)
      @configuration = Pipestalk.configuration.readonly
    end

    def configure #:yield:#
      @configuration = @configuration.writable
      yield configuration if block_given?
      configuration
    end

    def connection
      self
    end
  end
end
