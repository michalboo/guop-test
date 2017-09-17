require_relative "../spec_helper"

describe GuOP do
  before(:all) do
    @guop = GuOP.new($VALID_API_KEY)
  end

  describe "GET /search (serch queries)" do
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
        s1 = @guop.search("plague")
        s2 = @guop.search("cholera")

        expect(s1["results"]).not_to eq s2["results"]
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

      it "allows specifying multi-word phrases with double quotes" do
        # specific article title
        title = "Meaningless meetings and death by committee"
        expect(@guop.search("\"#{title}\"")["total"]).to eq 1
      end

      context "when combining search terms with logical operators" do
        before(:all) do
          @term_1 = "webdriver"
          @term_2 = "Appelquist"

          @search_1_total = @guop.search(@term_1)["total"]
          @search_2_total = @guop.search(@term_2)["total"]
        end

        it "supports the OR operator" do
          or_query = "#{@term_1} OR #{@term_2}"
          or_search_total = @guop.search(or_query)["total"]

          expect(or_search_total).to be > @search_1_total
          expect(or_search_total).to be > @search_2_total
        end

        it "supports the AND operator" do
          and_query = "#{@term_1} AND #{@term_2}"
          and_search_total = @guop.search(and_query)["total"]

          expect(and_search_total).to be < @search_1_total
          expect(and_search_total).to be < @search_2_total
        end

        it "supports the NOT operator" do
          and_total = @guop.search("#{@term_1} AND #{@term_2}")["total"]
          not_total = @guop.search("#{@term_1} AND NOT #{@term_2}")["total"]

          expect(not_total).to eq(@search_1_total - and_total)
        end
      end
    end
  end
end
