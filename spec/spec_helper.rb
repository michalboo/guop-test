require_relative "../lib/guop.rb"
require_relative "./support/api_schema_matcher.rb"

require "pry"
require "json"
require "json-schema"
require "securerandom"

$VALID_API_KEY = ENV["API_KEY"]
fail("API_KEY not available in ENV") unless $VALID_API_KEY

RSpec.configure do |config|
  config.formatter = :documentation
end
