# encoding: UTF-8

require 'webrick'

module ADN
  class TokenSaver < WEBrick::HTTPServlet::AbstractServlet

    def save_token(token)
      File.open(ADN::Auth::TOKEN_FILE, 'w') {|f| f.write(token) }
    end

    def do_GET(request, response)
      save_token(request.query['access_token'])
      ADN::Auth.server.stop
    end
  end

  module Auth
    TOKEN_FILE = File.expand_path("~/.adn-cli-token")
    CLIENT_ID  = 'bQQrxrhNXGVNrnZ6dTs6LDHfSfUFSX9Q'
    SCOPES     = ['stream', 'write_post']
    AUTH_URL   = "https://alpha.app.net/oauth/authenticate?client_id=#{CLIENT_ID}&response_type=token&redirect_uri=http://localhost:9229/authorize/&scope=#{SCOPES.join(',')}"
    PUBLIC     = File.expand_path(File.dirname(__FILE__)) + "/../../public"

    class << self
      def has_token?
        File.exists?(TOKEN_FILE)
      end

      def token
        @token ||= IO.read(TOKEN_FILE)
      end

      def retrieve_token
        puts "Retrieve OAuth2 token"
        launch_browser(AUTH_URL)
        server.start
      end

      def launch_browser(url)
        system "open \"#{url}\""
      end

      def server
        @server ||= begin
          httpd = WEBrick::HTTPServer.new(
            Port: 9229,
            Logger: WEBrick::Log.new("/dev/null"),
            AccessLog: [nil, nil]
          )

          httpd.tap { |s|
            s.mount "/authorize", WEBrick::HTTPServlet::FileHandler, ADN::Auth::PUBLIC
            s.mount "/save-token", ADN::TokenSaver
          }
        end
      end
    end
  end
end
