class Api::V1::WhiskeysController < ApplicationController
  def index
    whiskies = if params[:whiskey_brand_id]
                 Whiskey.filter_by_brand(params[:whiskey_brand_id]).order(:label)
               else
                 Whiskey.all.order(:label)
               end
    render json: whiskies
  end

  private

  def whiskey_params
    params.permit(:label, :whiskey_brand_id)
  end
end
