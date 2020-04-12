require 'faker'

FactoryBot.define do
  factory :whiskey, class: Whiskey do
    label { Faker::DcComics.heroine }
    whiskey_brand
  end
end