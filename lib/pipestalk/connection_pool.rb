module Pipestalk
  class ConnectionPool
    extend Forwardable

    delegate [:close, :connections, :jobs, :stats, :tubes,
              :transmit_to_all, :transmit_to_rand,
              :transmit_until_res] => :@pool

    include Base

    attr_reader :configuration, :pipes

    def initialize(addresses=nil)
      @configuration = Pipestalk::Configuration.new
      @pool = Beaneater::Pool.new(addresses)
      @pipes = {}
    end

    def configure #:yield:#
      yield configuration if block_given?
      configuration
    end

    def connection
      self
    end
  end
end
