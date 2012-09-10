# encoding: UTF-8

require 'pp'
require 'adn'
require 'ansi/core'
require 'ansi/table'

require_relative "cli/version"
require_relative "cli/global_stream"
require_relative "auth"

trap("INT"){ exit }

module ADN
  class CLI
    def self.run
      ADN::Auth.retrieve_token unless ADN::Auth.has_token?
      ADN.token = ADN::Auth.token
      new
    end

    def initialize
      if ARGV.empty? && STDIN.tty?
        GlobalStream.start
      else
        text = ARGF.read

        if text.length > 256
          abort ANSI.color(:red) { "Sorry, max 256 characters" }
        else
          ADN::Post.send_post text: text
        end
      end
    end
  end
end
