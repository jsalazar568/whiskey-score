class Api::V1::UsersController < ApplicationController
  def create
    user = User.create_or_update_by!(user_params.extract!(:email), user_params)
    render json: user, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.to_s }, status: :bad_request
  end

  private

  def user_params
    params.required(:user).permit(:email, :name)
  end
end
