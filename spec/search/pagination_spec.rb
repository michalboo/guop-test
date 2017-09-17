require_relative "../spec_helper"

describe GuOP do
  before(:all) do
    @guop = GuOP.new($VALID_API_KEY)
  end

  describe "GET /search (pagination)" do
    context "when called with 'page-size' parameter" do
      it "returns the correct number of results per page" do
        [0 ,1, 20, 200].each do |page_size_example|
          opts = { query: { "page-size" => page_size_example } }
          res = @guop.get("/search", opts).parsed_response["response"]

          expect(res["pageSize"]).to eq page_size_example
          expect(res["results"].length).to eq page_size_example
        end
      end

      it "returns a '400' error if page-size > 200" do
        expect(
          @guop.get("/search", query: { "page-size" => 201 }).code
        ).to eq 400
      end
    end

    context "when called with 'page' parameter" do
      before(:all) do
        @total_pages = @guop.search("democracy")["pages"]
        fail unless @total_pages > 2 # Test needs multiple pages of results
      end

      it "returns the specified result page" do
        [1, (2 + rand(@total_pages - 2)), @total_pages].each do |page_number|
          res = @guop.search("democracy", page: page_number)
          expect(res["currentPage"]).to eq page_number
        end
      end

      it "returns a '400' error if 'page' parameter invalid" do
        [0, @total_pages + 1, "thirteen"].each do |invalid_page|
          res = @guop.get("/search", query: { q: "democracy", page: invalid_page })
          expect(res.code).to eq 400
        end
      end
    end
  end
end
