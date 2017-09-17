require_relative "spec_helper"

describe GuOP do
  before(:all) do
    @guop = GuOP.new($VALID_API_KEY)
  end

  describe "GET /search" do
    context "when called with no querystring parameter" do
      before(:all) do
        @response = @guop.get("/search")
      end

      it "returns a '200' response" do
        expect(@response.code).to eq 200
      end

      it "returns valid JSON adhering to the 'search_result' schema" do
        expect{ JSON.parse @response.body }.not_to raise_error
        expect(@response.body).to match_schema("search_result")
      end

      it "returns a non-empty list of results" do
        search_results = @response.parsed_response["response"]["results"]
        expect(search_results).to be_instance_of Array
        expect(search_results.length).to be > 0
      end

      it "returns information on the total number of search results" do
        expect(@response.parsed_response["response"]["total"]).to be > 0
      end
    end

    context "when called with a querystring parameter" do
      it "returns diffferent results for different queries" do
        s1 = @guop.get("/search", query: { q: "plague" }).parsed_response
        s2 = @guop.get("/search", query: { q: "cholera" }).parsed_response

        expect(s1["response"]["results"]).not_to eq s2["response"]["results"]
      end

      it "handles multi-word queries" do
        resp = @guop.get("/search", query: { q: "prime minister" })
        expect(resp.code).to eq 200
        expect(resp.parsed_response["response"]["results"]).not_to be_empty
      end

      it "handles queries containing non-latin characters" do
        ["Michał", "在西方 毛泽东", "Москва"].each do |example|
          resp = @guop.get("/search", query: { q: example })
          expect(resp.code).to eq 200
          expect(resp.parsed_response["response"]["results"]).not_to be_empty
        end
      end
    end
  end
end
