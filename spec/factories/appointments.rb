FactoryGirl.define do
  factory :appointment do
    first_name 'Rick'
    last_name 'Sanchez'
    email 'rick@example.com'
    phone '0208 252 4758'
    opt_out_of_market_research true
    dc_pot_confirmed true
    memorable_word 'snootbooper'
    date_of_birth '1945-01-01'
    type_of_appointment '50-54'

    trait :with_slot do
      slot { build(:slot, :with_room) }
    end
  end
end
