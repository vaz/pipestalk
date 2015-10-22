module Pipestalk

  ##
  # A Pipe is a thin abstraction on top of beanstalk tubes
  # that can be connected to other Pipes to stream records
  # from one to the other, optionally filtering the records.
  #
  class Pipe
    extend Forwardable

    # TODO: simplify reserve?
    delegate [:clear, :kick, :pause, :peek, :reserve, :stats] => :@tube

    attr_reader :name, :connection, :tube

    def initialize(name, connection)
      @name = name
      @connection = connection || Pipestalk.connection
      @connection.pipes[name] = self
      @tube = @connection.tubes.find(qualified_name)
    end

    def namespace
      connection.configuration.namespace
    end

    def qualified_name
      "#{namespace}/#{name}"
    end

    def put(record, options={})
      options = default_put_options.merge(options)
      @tube.put(job_format(record), options)
    end
    alias_method :<<, :put

    def connect(*others) #:yield:#
      connection.jobs.register(@name) do |job|
        record = block_given?? yield(job.body, job) : job.body
        others.each { |other| other.put(record) } unless record.nil?
      end
    end
    alias_method :>>, :connect

    def get(options={})
      # TODO
      # some kind of simplified reserve?
    end

    private

    def default_put_options
      { delay: connection.configuration.default_put_delay,
        pri:   connection.configuration.default_put_pri,
        ttr:   connection.configuration.default_put_ttr }
    end

    def job_format(record)
      connection.configuration.job_formatter.call(record)
    end
  end
end
