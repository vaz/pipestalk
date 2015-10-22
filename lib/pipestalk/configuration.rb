module Pipestalk
  class Configuration
    extend Forwardable

    DELEGATED_READERS = [
      :default_put_delay,
      :default_put_pri,
      :default_put_ttr,
      :job_parser,
      :beanstalkd_url
    ]
    DELEGATED_WRITERS = DELEGATED_READERS.map { |m| :"#{m}=" }

    delegate DELEGATED_READERS.concat(
             DELEGATED_WRITERS) => :@beaneater_config

    OPTIONS = DELEGATED_READERS.concat([:job_formatter, :namespace])

    attr_accessor :job_formatter, :namespace

    def initialize
      @beaneater_config = Beaneater.configuration
      @beaneater_config.beanstalkd_url ||= ['localhost:11300']
      @job_formatter = Filter::IDENTITY
      @namespace = 'default'
    end
  end
end
