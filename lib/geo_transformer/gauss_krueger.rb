module GeoTransformer
  class GausKrueger
    include Math

    attr_reader :latitude, :longitude, :right, :height

    def initialize(right, height)
      @right = right.to_i
      @height = height.to_i
      convert_to_lat_lng
    end

    def convert_to_lat_lng
      x,y = gauss_krueger_transformation(@right, @height)
      @latitude, @longitude = seven_parameter_helmert_transf(x,y, false)
    end

    def to_geojson
      { type: "Point", coordinates: coordinates }
    end

    def coordinates
      [latitude, longitude]
    end

    def gauss_krueger_transformation(right, height)
      #check for invalid parameters
      if (not ((right > 1000000) and (height > 1000000)))
          #raise valueerror("no valid gauss-kruger-code.")
      end
      #variables to prepare the geovalues
      gkright = right
      gkheight = height
      e2 = 0.0067192188
      c = 6398786.849
      rho = 180 / Math::PI
      bii = (gkheight / 10000855.7646) * (gkheight / 10000855.7646)
      bf = 325632.08677 * (gkheight / 10000855.7646) * ((((((0.00000562025 * bii + 0.00022976983) * bii - 0.00113566119) * bii + 0.00424914906) * bii - 0.00831729565) * bii + 1))

      bf /= 3600 * rho
      co = cos(bf)
      g2 = e2 * (co * co)
      g1 = c / sqrt(1 + g2)
      t = tan(bf)
      fa = (gkright - (gkright / 1000000) * 1000000 - 500000).round / g1

      geodezright = ((bf - fa * fa * t * (1 + g2) / 2 + fa * fa * fa * fa * t * (5 + 3 * t * t + 6 * g2 - 6 * g2 * t * t) / 24) * rho)
      dl = fa - fa * fa * fa * (1 + 2 * t * t + g2) / 6 + fa * fa * fa * fa * fa * (1 + 28 * t * t + 24 * t * t * t * t) / 120
      geodezheight = dl * rho / co + (gkright / 1000000).round * 3

      return [geodezright, geodezheight]
    end

    def seven_parameter_helmert_transf(right, height, use_wgs84=false)
      earthradius = 6378137  # earth is a sphere with this radius
      abessel = 6377397.155
      eebessel = 0.0066743722296294277832
      scalefactor = 0.00000982
      rotxrad = -7.16069806998785e-06
      rotyrad = 3.56822869296619e-07
      rotzrad = 7.06858347057704e-06
      shiftxmeters = 591.28
      shiftymeters = 81.35
      shiftzmeters = 396.39
      latitudeit = 99999999

      if(use_wgs84)
          ee = 0.0066943799
      else
          ee = 0.00669438002290
      end

      geodezright = (right / 180) * Math::PI
      geodezheight = (height / 180) * Math::PI

      n = eebessel * sin(geodezright) * sin(geodezright)
      n = 1 - n
      n = sqrt(n)
      n = abessel / n

      cartesianxmeters = n * cos(geodezright) * cos(geodezheight)
      cartesianymeters = n * cos(geodezright) * sin(geodezheight)
      cartesianzmeters = n * (1 - eebessel) * sin(geodezright)

      cartoutputxmeters = (1 + scalefactor) * cartesianxmeters + rotzrad * cartesianymeters - rotyrad * cartesianzmeters + shiftxmeters
      cartoutputymeters = -1 * rotzrad * cartesianxmeters + (1 + scalefactor) * cartesianymeters + rotxrad * cartesianzmeters + shiftymeters
      cartoutputzmeters = rotyrad * cartesianxmeters - rotxrad * cartesianymeters + (1 + scalefactor) * cartesianzmeters + shiftzmeters

      geodezheight = atan(cartoutputymeters / cartoutputxmeters)

      latitude = (cartoutputxmeters * cartoutputxmeters) + (cartoutputymeters * cartoutputymeters)
      latitude = sqrt(latitude)
      latitude = cartoutputzmeters / latitude
      latitude = atan(latitude)

      not_accurate_enough = true

      while(not_accurate_enough)
          latitudeit = latitude

          n = 1 - ee * sin(latitude) * sin(latitude)
          n = sqrt(n)
          n = earthradius / n

          latitude = cartoutputxmeters * cartoutputxmeters + cartoutputymeters * cartoutputymeters
          latitude = sqrt(latitude)
          latitude = (cartoutputzmeters + ee * n * sin(latitudeit)) / latitude
          latitude = atan(latitude)

          not_accurate_enough = ((latitude - latitudeit).abs >= 0.000000000000001)
      end

      geodezright = (latitude / Math::PI ) * 180
      geodezheight = (geodezheight) / Math::PI * 180

      return([geodezright, geodezheight])
    end
  end
end
