class Api::V1::WhiskeyBrandsController < ApplicationController
  def index
    render json: WhiskeyBrand.all, status: :ok
  end

  def create
    brand = WhiskeyBrand.create!(whiskey_brand_params)
    render json: brand, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.to_s }, status: :bad_request
  end

  private

  def whiskey_brand_params
    params.permit(:name)
  end
end
