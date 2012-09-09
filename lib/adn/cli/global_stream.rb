# encoding: UTF-8

require 'yaml'

module ADN
  class CLI
    class GlobalStream
      def initialize(user)
        @user = user
      end

      def show
        get_global_feed.tap { |r|
          show_posts(r)
          update_since_id(r)
        }
      end

      private

      def get_global_feed
        params = {
          count: 10,
          include_directed_posts: 1,
          include_annotations: 1
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
        response['data'].reverse.each { |p|
          puts line + post_heading(p) + colorized_text(p)

          if p['annotations'].any?
            puts p['annotations'].to_yaml.ansi(:black)
          end
        }
      end

      def post_heading(p)
        user_str = "#{p['user']['username']}".ansi(:blue) +
                   " (#{p['user']['name'].strip})".ansi(:yellow)

        id_str   = p['id'].ansi(:black)

        spaces = ANSI::Terminal.terminal_width -
                 ANSI.unansi(user_str + id_str).length

        "#{user_str}#{" " * spaces}#{id_str}\n"
      end

      def colorized_text(p)
        text_color = p['user']['follows_you'] ? :cyan : :white
        text_color = :green if p['user']['you_follow']
        text_color = :magenta if p['user']['id'] == @user.user_id

        ANSI.color(text_color) { p['text'] }
      end

      def line(char = '_')
        "#{char * ANSI::Terminal.terminal_width}\n".ansi(:black)
      end
    end
  end
end
