require 'geo_transformer/gauss_krueger'

module GeoTransformer

  def self.parse_gauss_krueger(gk_string)
    right, height = gk_string.split(",")
    if right && height
      GausKrueger.new(right, height)
    else
      raise ArgumentError.new "invalid arg: #{gk_string}"
    end
  end
end
