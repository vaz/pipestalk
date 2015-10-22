require 'forwardable'
require 'beaneater'
require 'activesupport'
require 'pipestalk/version'
require 'pipestalk/connection_pool'
require 'pipestalk/filter'
require 'pipestalk/pipe'
require 'pipestalk/factory'
require 'pipestalk/configuration'

module Pipestalk
  extend Connection

  def connection
    @connection ||= ConnectionPool.new
  end
end
