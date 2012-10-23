# encoding: UTF-8

require 'yaml'

require_relative 'terminal_stream'

module ADN
  class CLI
    class GlobalStream < TerminalStream
      def show(options)
        get_global_stream.tap { |r|
          show_posts(r)
          update_since_id(r)
        }

        sleep options[:sleep]
      end

      private

      def get_global_stream
        params = {
          count: 10,
          include_directed_posts: 1,
          include_annotations: 1
        }

        params[:since_id] = @since_id unless @since_id.nil?

        ADN::API::Post.global_stream(params)
      end
    end
  end
end
