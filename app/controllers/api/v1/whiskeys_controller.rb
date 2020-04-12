class Api::V1::WhiskeysController < ApplicationController
  def index
    whiskies = Whiskey.filter_by_brand(params[:whiskey_brand_id])
                      .order(:label)
                      .all
    render json: whiskies
  end

  def create
    #OJO se usara?
    whiskey = Whiskey.new(whiskey_params)
    if whiskey
      render json: whiskey
    else
      render json: whiskey.errors
    end
  end

  private

  def whiskey_params
    params.permit(:label, :whiskey_brand_id)
  end
end
