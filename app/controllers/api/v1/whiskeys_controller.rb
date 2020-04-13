class Api::V1::WhiskeysController < ApplicationController
  def index
    whiskies = if params[:whiskey_brand_id]
                 Whiskey.filter_by_brand(params[:whiskey_brand_id]).order(:label)
               else
                 Whiskey.all.order(:label)
               end
    render json: whiskies, status: :ok
  end

  def create
    whiskey = Whiskey.create!(whiskey_params)
    render json: whiskey, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.to_s }, status: :bad_request
  end

  private

  def whiskey_params
    params.permit(:label, :whiskey_brand_id)
  end
end
