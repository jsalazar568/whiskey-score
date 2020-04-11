class Review < ApplicationRecord
  belongs_to :user
  belongs_to :whiskey

  validates :taste_grade,
            :color_grade,
            :smokiness_grade,
            {
                inclusion: { in: [1, 2, 3, 4, 5], message: "%{value} is not a valid grade" },
                allow_nil: true
            }
  validates :user, :whiskey, { presence: true }
  validates :user, { uniqueness: { scope: :whiskey, message: "already made a review to the whiskey" } }
end
