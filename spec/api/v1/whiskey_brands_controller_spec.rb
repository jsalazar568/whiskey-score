require 'rails_helper'
require 'faker'

RSpec.describe Api::V1::WhiskeyBrandsController do
  describe "GET #index" do
    before do
      create_list(:whiskey_brand, 3)
      get '/api/v1/whiskey_brands'
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "responds expected whiskey brand attributes" do
      hash_response = JSON.parse(response.body)
      expect(hash_response.length).to eq 3
      expect(hash_response[0].keys).to include('name', 'id')
    end
  end
end