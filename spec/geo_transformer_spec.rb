require 'spec_helper'

describe GeoTransformer do
  context "gauss krueger" do
    let(:gk_string) { "334459922,5999927" }
    it "parses a gauss_krueger string" do
      expect(GeoTransformer.parse_gauss_krueger(gk_string)).to be_a(GeoTransformer::GausKrueger)
    end

    context "string does not contain GK coordinates" do
      let(:gk_string) { "345529492" }
      it "returns an error" do
        expect {
          GeoTransformer.parse_gauss_krueger(gk_string)
        }.to raise_error(ArgumentError)
      end
    end
  end
end
