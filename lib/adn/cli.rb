# encoding: UTF-8

require 'optparse'

require 'adn'
require 'ansi/core'
require 'ansi/table'

require_relative "cli/version"
require_relative "cli/global_stream"
require_relative "cli/unified_stream"
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
      if STDIN.tty?
        if ["-u", "--unified"].include?(ARGV.first)
          UnifiedStream.start
        elsif ["-g", "--global"].include?(ARGV.first) || ARGV.empty?
          GlobalStream.start
        else
          puts "Unknown parameters: #{ARGV.inspect}"
        end
      else
        send_post $stdin.read.strip
      end
    end

    def send_post(text)
      if text.length > 256
        abort ANSI.color(:red) { "Sorry, max 256 chars" }
      end

      data = { text: text }

      OptionParser.new do |opts|
        opts.on("-r ID") { |id| data[:reply_to] = id }
      end.parse!

      ADN::Post.send_post data
    rescue OptionParser::ParseError => e
      abort "Error: #{e}"
    end
  end
end
