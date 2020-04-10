class Api::V1::ReviewsController < ApplicationController
  def index
  end

  def create
  end

  private

  def review_params
    params.permit(:taste_grade, :color_grade, :smokiness_grade, :title, :description, users_attributes: [:id], whiskeys_attributes: [:id])
  end
end
