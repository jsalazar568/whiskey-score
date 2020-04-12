require 'faker'

FactoryBot.define do
  factory :user, class: User do
    name { Faker::Food.fruits }
    email { Faker::Internet.email }
  end
end