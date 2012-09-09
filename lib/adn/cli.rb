# encoding: UTF-8

require 'adn'
require 'ansi/core'
require 'ansi/table'

require_relative "cli/version"
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
      response = ADN::API.get('https://alpha-api.app.net/stream/0/posts/stream/global')
      show_posts response['data']
    end

    private

    def show_posts(items)
      items.reverse.each do |p|
        line
        puts "#{p['user']['name']}:".ansi(:blue)
        puts p['text'].ansi(:green)
      end
    end

    def line(char = '—')
      puts "\n"
      puts "#{char * ANSI::Terminal.terminal_width}".ansi(:black)
    end
  end
end
