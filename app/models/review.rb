class Review < ApplicationRecord
  GRADE_ATTRIBUTES = %w[taste_grade color_grade smokiness_grade].freeze

  belongs_to :user
  belongs_to :whiskey

  validates :taste_grade,
            :color_grade,
            :smokiness_grade,
            {
                inclusion: { in: [1, 2, 3, 4, 5], message: '%{value} is not a valid grade' },
                allow_nil: true
            }
  validates :user, :whiskey, { presence: true }
  validates :user, { uniqueness: { scope: :whiskey, message: 'already made a review to the whiskey' } }

  scope :filter_by_grades, ->(grade_hash) { where(grade_hash) }
  scope :filter_by_text, -> (text) { where("title ILIKE ? OR description ILIKE ?", "%#{text.downcase}%", "%#{text.downcase}%") }

  def self.create_or_update_by!(search_args = {}, update_attributes = {})
    raise StandardError, 'Invalid parameters' if (search_args[:user_id].blank? || search_args[:whiskey_id].blank?)

    review = Review.find_or_initialize_by({ user_id: search_args[:user_id], whiskey_id: search_args[:whiskey_id]})
    review.update!(update_attributes)
    review
  end

  def self.filter_by(params)
    reviews = filter_by_grades(grade_params(params))
    if params[:text_search]
      reviews = reviews.filter_by_general_text(params[:text_search])
    end
    if (params[:whiskey_brand_ids])
      reviews = reviews.filter_by_brands(params[:whiskey_brand_ids])
    end
    reviews
  end

  def self.filter_by_general_text(text)
    where('reviews.id IN (?) OR reviews.id IN (?)',
          Review.filter_by_text(text).ids,
          Review.joins(:whiskey).merge(Whiskey.filter_by_label(text)).ids)
  end

  def self.filter_by_brands(brand_ids)
    joins(:whiskey).merge(Whiskey.filter_by_brand(brand_ids))
  end

  private

  def self.grade_params(params)
    params.select {|k,_| GRADE_ATTRIBUTES.include?(k)}
  end
end
