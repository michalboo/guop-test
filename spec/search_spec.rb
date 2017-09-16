require_relative "spec_helper"

describe GuOP do
  before(:all) do
    @guop = GuOP.new($VALID_API_KEY)
  end

  describe "GET /search" do
    context "when called with no query argument"
    before(:all) do
      @response = @guop.get("/search")
    end

    it "returns a '200' response" do
      expect(@response.code).to eq 200
    end

    it "returns valid json adhering to the 'search_result' schema" do
      expect{ JSON.parse @response.body }.not_to raise_error
      expect(@response.body).to match_schema("search_result")
    end

    it "returns a non-empty list of results" do
      search_results = @response.parsed_response["response"]["results"]
      expect(search_results).to be_instance_of Array
      expect(search_results.length).to be > 0
    end
  end
end
