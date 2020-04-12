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
  scope :filter_by_text, -> (text) { where("to_tsvector(title || ' ' || description) @@ to_tsquery('#{text.gsub(/[[:blank:]]/, '&')}')") }


  def self.filter_by(params)
    reviews = filter_by_grades(grade_params(params))
    if(params[:text_search])
      reviews = reviews.where('reviews.id IN (?) OR reviews.id IN (?)',
                              Review.filter_by_text(params[:text_search]).ids,
                              Review.joins(:whiskey).merge(Whiskey.filter_by_label(params[:text_search])).ids)
    end
    if(params[:whiskey_brand_ids])
      reviews = reviews.joins(:whiskey)
                       .merge(Whiskey.filter_by_brand(params[:whiskey_brand_ids]))
    end
    reviews
  end

  private

  def self.grade_params(params)
    params.select {|k,_| GRADE_ATTRIBUTES.include?(k)}
  end
end
