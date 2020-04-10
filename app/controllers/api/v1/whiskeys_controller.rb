class Api::V1::WhiskeysController < ApplicationController
  def index
    whiskies = Whiskey.includes(:whiskey_brand).order(:'whiskey_brand.name', :label).all
    render json: whiskies
  end

  def create
    whiskey = Whiskey.new(whiskey_params)
    if whiskey
      render json: whiskey
    else
      render json: whiskey.errors
    end
  end

  def show
    whiskey = Whiskey.find_by
  end

  private

  def whiskey_params
    params.permit(:label, whiskey_brands_attributes: [:name, :id])
  end
end
