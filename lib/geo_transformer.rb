require 'geo_transformer/gauss_krueger'

module GeoTransformer

  def self.parse_gauss_krueger(gk_string)
    right, height = gk_string.split(",")
    GausKrueger.new(right, height)
  end
end
