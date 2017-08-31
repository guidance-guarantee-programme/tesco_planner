class LocationSerializer < ActiveModel::Serializer
  attributes %i[
    id
    name
    address_line_one
    address_line_two
    address_line_three
    town
    county
    postcode
  ]
end
