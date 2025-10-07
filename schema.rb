# How to test
# $ gem install 'dry-schema'
# $ ruby test.rb

require 'dry-schema'
require 'dry-types'
require 'debug'

Types = Dry.Types()

MyStrictSchema = Dry::Schema.JSON do
  required(:name).filled(:string)
  optional(:email).maybe(:string)
  optional(:favorite_foods).maybe(:array).each do
    hash? do
      before(:value_coercer) do |result|
        # binding.break
        result.to_h.select { _1.is_a?(Hash) }
      end
      required(:name).filled(:string)
      required(:weight_in_grams).filled(:integer)
    end
  end
end


# result = MyStrictSchema.call({ "name" => "Vini",  "email" => "vini@example.com", unused_field: "doesnt-matter" })

# puts "Case 1: ==="
# if result.success?
#   coerced_data = result.to_h
#   puts "Coerced data: #{coerced_data}"
# else
#   puts "Validation errors: #{result.errors.to_h}"
# end

# # Valid (email can be nil)
# puts "Case 2: ==="
# result = MyStrictSchema.call({ "name" => "Vini" })

# if result.success?
#   coerced_data = result.to_h
#   puts "Coerced data: #{coerced_data}"
# else
#   puts "Validation errors: #{result.errors.to_h}"
# end

# # Invalid
# puts "Case 3: ==="
# result = MyStrictSchema.call({ "email" => "john@example.com" })

# if result.success?
#   coerced_data = result.to_h
#   puts "Coerced data: #{coerced_data}"
# else
#   coerced_data = result.to_h

#   puts "Validation errors: #{result.errors.to_h}"end


# # foods
# puts "Case 4: ==="
# result = MyStrictSchema.call({ "name" => "Vini", favorite_foods: [
#   { name: "sushi", weight_in_grams: 100 },
#   { name: "more sushi", weight_in_grams: 200 }
# ] })

# if result.success?
#   coerced_data = result.to_h
#   puts "Coerced data: #{coerced_data}"
# else
#   puts "Validation errors: #{result.errors.to_h}"
# end

# foods (array with boolean)
puts "Case 5: ==="
result = MyStrictSchema.call({ "name" => "Vini", favorite_foods: [
  { name: "sushi", weight_in_grams: 100 },
  { name: "more sushi", weight_in_grams: 200 },
  false
] })

if result.success?
  coerced_data = result.to_h
  puts "Coerced data: #{coerced_data}"
else
  puts "Validation errors: #{result.errors.to_h}"
end

