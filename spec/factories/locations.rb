FactoryBot.define do
  factory :location do
    sequence(:name) { |n| "Tesco #{n}" }

    address_line_one { '1 Some Street' }
    address_line_two { 'Some Place' }
    address_line_three { '' }
    town { 'Some Town' }
    county { 'Some County' }
    postcode { 'RG2 9FL' }
    delivery_centre
    employer
  end
end
