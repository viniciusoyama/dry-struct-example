require 'dry-struct'
require 'dry-types'

module Types
  include Dry.Types()
end

# Example using a custom schema for a nested array field with a custom type
# favorite_foods is an array of FavoriteFoodSchema, it can be nil (no default value is set)
# If favorite_foods contains non hash values, it raises an error
class SiteData < Dry::Struct
  transform_keys(&:to_sym)

  class FavoriteFoodSchema < Dry::Struct
    transform_keys(&:to_sym)
    attribute :name, Types::String
    attribute :weight_in_grams, Types::Integer
  end

  attribute :name, Types::String
  attribute? :email,  Types::String
  attribute? :favorite_foods, Types::Array.of(FavoriteFoodSchema)
end

# Example using a custom schema for a nested array (we don't need to create a custom type if we don't want to)
# if favorite_foods is nil, it's set to an empty array 
# if favorite_foods contains non hash values, it just ignores them

class CoersibleSiteData < Dry::Struct
  transform_keys(&:to_sym)

  attribute :name, Types::String
  attribute? :email,  Types::String
  attribute :favorite_foods, Types::Array.constructor( ->(foods) {
    foods.select { _1.is_a?(Hash) }
  }).default([].freeze) do
    attribute :name, Types::String
    attribute :weight_in_grams, Types::Integer
  end
end

puts "=== USING SiteData ==="

# Json with a field that we don't care about (it's ignored)
result = SiteData.new({ "name" => "Vini",  "email" => "vini@example.com", unused_field: "doesnt-matter" })

puts result.name

# THIS is NIL
puts result.favorite_foods.inspect

puts "\n===== 1 ====="

# Json with a valid foods array
result = SiteData.new({ "name" => "Vini", favorite_foods: [
  { name: "sushi", weight_in_grams: 100 },
  { name: "more sushi", weight_in_grams: 200 }
] })
puts result.favorite_foods.map(&:name)

puts "\n===== 2 ====="


# Json with a INVALID foods array
# This will raise an error
# "`Hash': can't convert FalseClass into Hash (TypeError)"
begin
  result = SiteData.new({ "name" => "Vini", favorite_foods: [
    { name: "sushi", weight_in_grams: 100 },
    { name: "more sushi", weight_in_grams: 200 },
    false
  ] })
rescue => e
  puts "Error: #{e}"
end


#### ==============================
# Using CoersibleSiteData, we can handle errors to fallback to expected values
# and data structures
#### ==============================

puts "\n===== USING CoersibleSiteData ====="


puts "\n===== 3 ====="

result = CoersibleSiteData.new({ "name" => "Vini"})

puts result.name
# NOT NIL ANYMORE, It's an []
puts result.favorite_foods.inspect


puts "\n===== 4 ====="
result = CoersibleSiteData.new({ "name" => "Vini", favorite_foods: [
  { name: "sushi", weight_in_grams: 100 },
  { name: "more sushi", weight_in_grams: 200 },
  false
] })

puts result.name

# it filters non hash values
puts result.favorite_foods.inspect
