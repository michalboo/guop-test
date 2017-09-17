require_relative "../spec_helper"

describe GuOP do
  before(:all) do
    @guop = GuOP.new($VALID_API_KEY)
  end

  describe "GET /search (filter by secion)" do
    context "calling a query with results from multiple sections" do
      before(:all) do
        @search_term = "webdriver"
        all_results = @guop.search(@search_term)["results"]
        @sections = all_results.collect {|r| r["sectionId"]}.uniq

        expect(@sections.length).to be > 1
      end

      context "when called with a valid 'section' parameter" do
        it "only returns results belonging to the specified section" do
          section = @sections.sample
          results = @guop.search(@search_term, section: section)["results"]
          result_sections = results.collect {|r| r["sectionId"]}.uniq

          expect(result_sections.length).to eq 1
          expect(result_sections.first).to eq section
        end
      end

      context "when called with a 'section' name prepended with a '-'" do
        it "excludes results belonging to the specified section" do
          section = @sections.sample

          results = @guop.search(@search_term, section: "-#{section}")["results"]
          result_sections = results.collect {|r| r["sectionId"]}.uniq

          expect(result_sections).not_to include(section)
        end
      end

      context "when called with an nonexistent 'section' parameter" do
        it "returns an empty list of results" do
          filter_ops = { query: { q: @search_term, section: "fakesection" } }
          results = @guop.search(@search_term, section: "fakesection")["results"]

          expect(results.length).to eq 0
        end
      end
    end
  end
end
