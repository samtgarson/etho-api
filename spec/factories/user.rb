require 'faker'

FactoryGirl.define do
  counts = {
    media: 63,
    followed_by: 187,
    follows: 166
  }
  factory :user do
    _id { Faker::Number.number(6) }
    username { Faker::Internet.user_name }
    full_name { Faker::Name.name }
    counts counts
    updated_at { Time.now }
    created_at { Time.now }
  end
end
