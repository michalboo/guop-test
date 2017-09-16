require_relative "spec_helper"

describe GuOP do
  describe "::new" do
    it "takes a single argument" do
      expect{ GuOP.new }.to raise_error(ArgumentError)
      expect{ GuOP.new("one", "two") }.to raise_error(ArgumentError)

      expect{ GuOP.new("test") }.not_to raise_error
    end
  end
end
