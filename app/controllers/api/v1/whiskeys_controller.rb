class Api::V1::WhiskeysController < ApplicationController
  def index
    whiskies = Whiskey.filter_by_brand(params[:whiskey_brand_id])
                      .order(:label)
                      .all
    render json: whiskies
  end

  private

  def whiskey_params
    params.permit(:label, :whiskey_brand_id)
  end
end
