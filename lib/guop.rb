require "httparty"

class GuOP
  include HTTParty

  base_uri "http://content.guardianapis.com"
  debug_output $stdout if ENV["VERBOSE"] == "true"

  def initialize(api_key)
    @api_key = api_key
  end

  def request(request_method, endpoint, opts = {})
    # apply default api-key
    default = { "api-key" => @api_key }
    opts[:query] = opts[:query] ? default.merge(opts[:query]) : default
    self.class.send(request_method, endpoint, opts)
  end
end
