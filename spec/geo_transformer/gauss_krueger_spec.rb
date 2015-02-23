require 'spec_helper'

describe GeoTransformer::GaussKrueger do
  subject { GeoTransformer::GaussKrueger.new(right, height) }
  let(:right) { 3454330 }
  let(:height) { 5433234 }
  it "is valid" do
    expect(subject).to be_a(GeoTransformer::GaussKrueger)
  end

  describe "#coordinates" do
    it "returns an array of coordinates" do
      expect(subject.coordinates).to be_an(Array)
    end
  end

end
