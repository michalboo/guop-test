require_relative "../spec_helper"

describe GuOP do
  before(:all) do
    @guop = GuOP.new($VALID_API_KEY)
  end

  describe "GET /search (filter by date)" do
    before(:all) do
      @term = "caracara"
      @cutoff_example = "2012-01-01"
    end

    context "when called with a 'from-date' parameter" do
      it "returns articles published after the specified date" do
        resp = @guop.search(@term, "from-date" => @cutoff_example)
        dates = resp["results"].collect do |r|
          DateTime.parse(r["webPublicationDate"])
        end.sort

        expect(dates.first).to be > DateTime.parse(@cutoff_example)
      end
    end

    context "when called with a 'to-date' parameter" do
      it "returns articles published before the specified date" do
        resp = @guop.search(@term, "to-date" => @cutoff_example)
        dates = resp["results"].collect do |r|
          DateTime.parse(r["webPublicationDate"])
        end.sort

        expect(dates.last).to be < DateTime.parse(@cutoff_example)
      end
    end

    context "when both from- and to- dates are specified" do
      it "returns articles published between the two dates" do
        from = "2010-10-10"
        to = "2015-01-01"

        resp = @guop.search(@term, "from-date" => from, "to-date" => to)
        dates = resp["results"].collect do |r|
          DateTime.parse(r["webPublicationDate"])
        end.sort

        expect(dates.first).to be > DateTime.parse(from)
        expect(dates.last).to be < DateTime.parse(to)
      end
    end

    context "when called with an invalid date parameter" do
      it "returns a '400' response status code" do
        ["yes", "Thursday 25th of June"].each do |invalid_example|
          response = @guop.get(
            "/search",
            { query: { q: @term, "from-date" => invalid_example } }
          )
          expect(response.code).to eq(400)
        end
      end
    end

    context "when the from- date is greater than the to- date" do
      it "returns no results" do
        response = @guop.search(
          @term,
          "from-date" => "2015-01-01",
          "to-date" => "2010-10-10"
        )
        expect(response["results"]).to be_empty
      end
    end
  end
end
