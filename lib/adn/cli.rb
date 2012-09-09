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

      trap("INT"){ exit }

      loop {
        show_global_feed
        sleep 4
      }
    end

    def show_global_feed
      get_global_feed.tap do |r|
        show_posts(r)
        update_since_id(r)
      end
    end

    private

    def get_global_feed
      params = {
        count: 10,
        include_directed_posts: 1
      }

      params[:since_id] = @since_id unless @since_id.nil?

      ADN::API::Post.global_stream(params)
    end

    def update_since_id(response)
      if response['data'].any?
        @since_id = response['data'].first['id']
      end
    end

    def show_posts(response)
      response['data'].reverse.each do |p|
        line

        user_str = "#{p['user']['username']}".ansi(:blue) +
                   " (#{p['user']['name'].strip})".ansi(:yellow)

        id_str   = "id: #{p['id'].ansi(:cyan)}"

        spaces = ANSI::Terminal.terminal_width -
                 ANSI.unansi(user_str + id_str).length

        puts "#{user_str}#{" " * spaces}#{id_str}\n\n#{p['text']}"
      end
    end

    def line(char = '—')
      puts "\n"
      puts "#{char * ANSI::Terminal.terminal_width}".ansi(:black)
    end
  end
end
