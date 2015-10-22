require 'forwardable'
require 'beaneater'
#require 'active_support/all'
require 'pipestalk/version'
require 'pipestalk/pipe'
require 'pipestalk/filter'
require 'pipestalk/factory'
require 'pipestalk/connection_pool'
require 'pipestalk/configuration'

module Pipestalk
  extend Connection

  def self.connection
    @connection ||= ConnectionPool.new
  end
end
