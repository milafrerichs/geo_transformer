# GeoTransformer
(name to be changed)

gem to help you transform geo objects.  

## Gauss Krüger
In Germany we have many institutions that pusblish their data with
[Gauss-Krüger](http://en.wikipedia.org/wiki/Gauss–Krüger_coordinate_system) coordinate system instead of the much more common
[UTM/WGS84](http://en.wikipedia.org/wiki/Universal_Transverse_Mercator_coordinate_system) system.

This gem will help you transform Gauss-Krüger coordinates to
latitude/longitude and GeoJSON.

# Installation

In your application's Gemfile:

```ruby
gem 'geo_transformer'
```

Or install it manually:

```sh
$ gem install geo_transformer
```

## Usage

```ruby
require 'geo_transformer'
```
### Create a GaussKrueger object from a coordinate string
```ruby
gauss_krueger = GeoTransformer.parse_gauss_krueger("3391608,5772857")
```

Now you have a GaussKrueger object and get the coordinates array
```ruby
gauss_krueger.coordinates
=> [52.07885102646202,7.417808649064127]
```
or a GeoJSON Point
```ruby
gauss_krueger.to_geojson
=> { "type" => "Point, "geometry" => [52.07885102646202,7.417808649064127] }
```

