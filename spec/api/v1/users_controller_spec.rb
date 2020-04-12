require 'rails_helper'
require 'faker'

RSpec.describe Api::V1::UsersController do
  describe "POST #create" do
    email = Faker::Internet.email
    name = Faker::Food.vegetables

    before do
      post '/api/v1/users', params: { user: { email: email } }
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "responds expected user attributes" do
      hash_response = JSON.parse(response.body)
      p hash_response
      expect(hash_response.keys).to include('email', 'name', 'id')
    end

    it "responds expected user values" do
      hash_response = JSON.parse(response.body)
      expect(hash_response['email']).to eq email.upcase
      expect(hash_response['name']).to eq nil
    end

    it "responds expected recipe attributes" do
      post '/api/v1/users', params: { user: {email: email, name: name} }
      hash_response = JSON.parse(response.body)
      expect(hash_response['email']).to eq email.upcase
      expect(hash_response['name']).to eq name
      expect(User.find(hash_response['id']).name).to eq name
    end
  end
end