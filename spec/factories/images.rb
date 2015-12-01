require 'faker'

FactoryGirl.define do
  factory :image do
    tags { Faker::Hipster.words(rand(50)) }
    location { "#{Faker::Address.street_address}, #{Faker::Address.city}" }
    filter { Faker::Hipster.words(1) }
    comments { rand(50) }
    created_at { Faker::Time.backward(100) }
    likes { rand(100) }
    link { Faker::Internet.url }
    caption { Faker::Hacker.say_something_smart }
    _id { Faker::Number.number(20).to_s }
    type { [:image, :video].sample }

    urls { { big: 'spec/fixtures/test_image.jpg', small: 'spec/fixtures/test_image.jpg' } }

    trait :summer_morning do
      created_at DateTime.new(2015, 7, 10, 9)
    end

    trait :winter_evening do
      created_at DateTime.new(2015, 1, 10, 21)
    end

    trait :lots_of_tags do
      tags Array.new(40) { 'common_tag' } + Array.new(20) { 'another_common_tag' }
    end

    trait :not_many_tags do
      tags Array.new(4) { 'uncommon_tag' } + Array.new(8) { 'another_uncommon_tag' }
    end
  end
end
