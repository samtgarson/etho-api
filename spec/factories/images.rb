require 'faker'

FactoryGirl.define do
  factory :image do
    tags { Faker::Hipster.words(10, false, true) }
    location { "#{Faker::Address.street_address}, #{Faker::Address.city}" }
    filter { Faker::Hipster.words(1) }
    comments { rand(50) }
    created_time { Faker::Time.backward(100) }
    likes { rand(100) }
    link { Faker::Internet.url }
    caption { Faker::Hacker.say_something_smart }
    _id { Faker::Number.number(20) }
    type { %w(image video).sample }

    url { Faker::Internet.url }
    palette []
    processed false
    season ''
  end
end
