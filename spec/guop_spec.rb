require_relative "spec_helper"

describe GuOP do
  describe "::new" do
    it "fails when called with no arguments" do
      expect{ GuOP.new }.to raise_error(ArgumentError)
    end
  end

  describe "#status" do
    context "when called with a valid api-key" do
      before(:all) do
        @guop = GuOP.new($VALID_API_KEY)
        @response = @guop.healthcheck
      end

      it "returns a '200' response code" do
        expect(@response.code).to eq 200
      end

      it "returns valid json adhering to the 'healthcheck' schema" do
        expect{ JSON.parse @response.body }.not_to raise_error
        expect(@response.body).to match_response_schema("healthcheck")
      end

      it "reports an 'ok' status" do
        expect(@response.parsed_response["response"]["status"]).to eq "ok"
      end

      it "includes rate limiting information in the response headers" do
        ratelimit_headers = [
          "x-ratelimit-limit-day",
          "x-ratelimit-limit-minute",
          "x-ratelimit-remaining-day",
          "x-ratelimit-remaining-minute"
        ]
        expect(@response.headers).to include *ratelimit_headers
      end
    end
  end
end
