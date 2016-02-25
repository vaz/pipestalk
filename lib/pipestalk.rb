require 'forwardable'
require 'beaneater'
require 'pipestalk/version'
require 'pipestalk/pipe'
require 'pipestalk/filter'
require 'pipestalk/base'
require 'pipestalk/connection_pool'
require 'pipestalk/configuration'

module Pipestalk
  extend Base

  def self.connection
    @connection ||= ConnectionPool.new
  end
end
