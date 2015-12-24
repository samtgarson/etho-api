FactoryGirl.define do
  factory :palette do
    scores { Array.new(4) { { hex: Sinebow.new(50).to_hex.sample, score: Faker::Number.between(0, 20) } } }
    primary { Sinebow.primary_hex.sample }
  end
end
