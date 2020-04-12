class Api::V1::ReviewsController < ApplicationController
  def index
    user = User.find(review_params[:user_id])
    reviews = user.reviews.filter_by(review_params)
    render json: reviews, status: :ok
  end

  def create
    review = Review.create_or_update_by!(review_params.extract!(:user_id, :whiskey_id), review_params)
    render json: review, status: :ok
  rescue StandardError, ActiveRecord::RecordInvalid => e
    render json: { error: e.to_s }, status: :bad_request
  end

  private

  def review_params
    params.permit(
        :user_id, :title, :description,
        :taste_grade, :color_grade, :smokiness_grade, :text_search,
        :whiskey_id, whiskey_brand_ids: []
    )
  end
end
