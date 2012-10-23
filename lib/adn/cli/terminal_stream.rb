# encoding: UTF-8

require 'yaml'

module ADN
  class CLI
    class TerminalStream
      include ANSI::Code
      include ANSI::Terminal

      def self.start
        stream = new(ADN::User.me)
        loop { stream.show sleep: 4 }
      rescue SocketError
        exit
      end

      def initialize(user)
        @user = user
      end


      def show(options)
        get_stream.tap do |r|
          show_posts(r)
          update_since_id(r)
        end

        sleep options[:sleep]
      end

      def get_stream
        raise NoMethodError, "Should be implemented by child class"
      end

      private

      def update_since_id(response)
        if response['data'].any?
          @since_id = response['data'].first['id']
        end
      end

      def show_posts(response)
        response['data'].reverse.each do |p|
          puts line + post_heading(p) + colorized_text(p)
          puts p['annotations'].to_yaml.ansi(:black) if p['annotations'].any?
        end
      end

      def post_heading(p)
        heading_line "#{p['user']['username']}".ansi(:blue) +
                     " (#{p['user']['name'].strip})".ansi(:yellow),
                     p['id'].ansi(:black)
      end

      def heading_line(left,right)
        spaces = terminal_width - unansi(left + right).length
        "#{left}#{" " * spaces}#{right}\n"
      end

      def colorized_text(p)
        text_color = p['user']['follows_you'] ? :cyan : :white
        text_color = :green if p['user']['you_follow']
        text_color = :magenta if p['user']['id'] == @user.user_id

        p['entities']['mentions'].tap do |mentions|
          if mentions.any? &&
             mentions.map { |m| m['id'] }.include?(@user.user_id)
            text_color = :red
          end
        end

        ANSI.color(text_color) { p['text'] }
      end

      def line(char = '_')
        "#{char * terminal_width}\n".ansi(:black)
      end
    end
  end
end
