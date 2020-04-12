class Api::V1::ReviewsController < ApplicationController
  def index
    user = User.find(review_params[:user_id])
    reviews = user.reviews.filter_by(review_params)
    render json: reviews, status: :ok
  end

  def create
  end

  private

  def review_params
    params.permit(
        :user_id, :title, :description,
        :taste_grade, :color_grade, :smokiness_grade, :text_search,
        whiskey_brand_ids: [],
        users_attributes: [:id],
        whiskeys_attributes: [:id]
    )
  end
end
