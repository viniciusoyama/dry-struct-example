This is a code snipped showing how we can use `dry-struct` to transform JSON/Hash into a 'Struct' (objects that we access data using methods instead of `[]`). This approach helps to:

- Document the expected json structure
- Handle default values if any field is missing
- Implement fallbacks if a type coercion fails. 

# Usage

- Run `bundle install`
- Run `bundle exec ruby struct.rb`
