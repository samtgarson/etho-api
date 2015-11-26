FactoryGirl.define do
  factory :palette do
    scores { Array.new(4) { { hex: Faker::Number.number(6), score: Faker::Number.between(1000, 2000).to_f / 10000 } } }
    primary { Faker::Number.number(6) }
  end
end
