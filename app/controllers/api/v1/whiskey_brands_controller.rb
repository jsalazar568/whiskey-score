class Api::V1::WhiskeyBrandsController < ApplicationController
  def index
    render json: WhiskeyBrand.all, status: :ok
  end
end
