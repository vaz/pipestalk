module Pipestalk
  class Configuration
    DELEGATED_READERS = [
      :default_put_delay,
      :default_put_pri,
      :default_put_ttr,
      :job_parser,
      :beanstalkd_url
    ]
    DELEGATED_WRITERS = DELEGATED_READERS.map { |m| :"#{m}=" }

    delegate DELEGATED_READERS.concat(
             DELEGATED_WRITERS) => :@beaneater_configuration

    OPTIONS = DELEGATED_READERS.concat([:job_formatter, :namespace])

    attr_accessor :job_formatter, :namespace

    def initialize
      @beaneater_config = Beaneater.configuration
      @beaneater_config[:beanstalkd_url] ||= ['localhost:11300']
      @job_formatter = Filter::IDENTITY
    end

    ##
    # A read-only proxy to the configuration.
    #
    # Connections can have their own configurations, but default
    # to delegating to the main configuration (Pipestalk.configuration).
    # If a connection is explicitly configured, it will be based off
    # its own copy of this configuration.
    class Readonly
      extend Forwardable

      delegate Configuration::OPTIONS => :@configuration

      def initialize(configuration)
        @configuration = configuration
      end

      def writable_dup
        @configuration.dup
      end
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration) if block_given?
      configuration
    end
  end
end
