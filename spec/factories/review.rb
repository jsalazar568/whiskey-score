require 'faker'

FactoryBot.define do
  grade = [1, 2, 3, 4, 5]

  factory :review, class: Review do
    title { Faker::DcComics.hero }
    description { Faker::DcComics.name }
    taste_grade { grade.sample }
    color_grade { grade.sample }
    smokiness_grade { grade.sample }
    whiskey
    user
  end
end