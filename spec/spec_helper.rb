require_relative "../lib/guop.rb"
require "pry"

$VALID_API_KEY = ENV["API_KEY"]
fail unless $VALID_API_KEY

RSpec.configure do |config|
  config.formatter = :documentation
end

