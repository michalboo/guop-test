require_relative "spec_helper"

describe GuOP do
  describe "GET / (healthcheck)" do
    context "when called with a valid api-key" do
      before(:all) do
        @guop = GuOP.new($VALID_API_KEY)
        @response = @guop.get("/")
      end

      it "returns a 200 response code" do
        expect(@response.code).to eq 200
      end

      it "returns valid JSON adhering to the 'healthcheck' schema" do
        expect{ JSON.parse @response.body }.not_to raise_error
        expect(@response.body).to match_schema("healthcheck")
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

    context "when called with no api-key" do
      it "returns a 401 response code" do
        response = GuOP.get("/")
        expect(response.code).to eq 401
      end
    end

    context "when called with invalid api-key" do
      it "returns a 403 response code" do
        response = GuOP.new(SecureRandom.uuid).get("/")
        expect(response.code).to eq 403
      end
    end
  end
end
