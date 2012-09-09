# encoding: UTF-8

require 'adn'
require 'ansi/core'
require 'ansi/table'

require_relative "cli/version"
require_relative "cli/global_stream"
require_relative "auth"

module ADN
  class CLI
    include ANSI::Code

    def self.run
      ADN::Auth.retrieve_token unless ADN::Auth.has_token?
      new(ADN::Auth.token)
    end

    def initialize(token)
      ADN.token = token

      trap("INT"){ exit }

      global_stream = GlobalStream.new

      loop {
        global_stream.show
        sleep 4
      }
    rescue SocketError
      exit
    end
  end
end
