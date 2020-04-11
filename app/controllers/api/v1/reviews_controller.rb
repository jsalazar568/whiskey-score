class Api::V1::ReviewsController < ApplicationController
  def index
    user = User.find(review_params[:user_id])
    render json: user.reviews, status: :ok
  end

  def create
  end

  private

  def review_params
    params.permit(
        :user_id, :taste_grade, :color_grade, :smokiness_grade, :title, :description, :text_search,
               users_attributes: [:id],
               whiskeys_attributes: [:id]
    )
  end
end
