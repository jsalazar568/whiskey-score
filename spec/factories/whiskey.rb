require 'faker'

FactoryBot.define do
  factory :whiskey, class: Whiskey do
    label { Faker::DcComics.heroine }
    association :whiskey_brand
  end
end