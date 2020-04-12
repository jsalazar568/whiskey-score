require 'faker'

FactoryBot.define do
  factory :whiskey_brand, class: WhiskeyBrand do
    name { Faker::Beer.brand }
  end
end