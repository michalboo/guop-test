require "httparty"

class GuOP
  include HTTParty

  base_uri "http://content.guardianapis.com"
  # debug_output $stdout

  def initialize(api_key)
    @api_key = api_key
  end

  def healthcheck
    # Healthcheck endpoint appears to live under "/"
    guop_request(:get, "/")
  end

  private
  def guop_request(request_method = :get, endpoint = "/")
    self.class.send(request_method, endpoint, { query: { "api-key" => @api_key }})
  end
end
