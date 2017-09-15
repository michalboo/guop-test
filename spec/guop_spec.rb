require_relative "spec_helper"

describe GuOP do
  describe "::new" do
    it "fails when called with no arguments" do
      expect{ GuOP.new }.to raise_error(ArgumentError)
    end
  end

  describe "#status" do
    context "when called with valid api-key" do
      before(:all) do
        @guop = GuOP.new($VALID_API_KEY)
        @response = @guop.healthcheck
      end

      it "returns a '200' response code" do
        expect(@response.code).to eq 200
      end

      it "includes API status information in the response body" do
        expect(@response.parsed_response["response"]).to be_instance_of Hash
        expect(@response.parsed_response["response"].keys).to include "status"
        expect(@response.parsed_response["response"]["status"]).to eq "ok"
      end
    end
  end

end
