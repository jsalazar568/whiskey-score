require 'rails_helper'
require 'faker'

RSpec.describe Api::V1::WhiskeysController do
  describe "GET #index" do
    before do
      WhiskeyBrand.create(id: 1, name: 'A Whiskey Brand')
      WhiskeyBrand.create(id: 2, name: 'Another Whiskey Brand')
      WhiskeyBrand.create(id: 3, name: 'A third Whiskey Brand')
      Whiskey.create(id: 1, label: 'This is a label', whiskey_brand_id: 1)
      Whiskey.create(id: 2, label: 'This is a label', whiskey_brand_id: 2)
      Whiskey.create(id: 3, label: 'This is another label', whiskey_brand_id: 2)

      get '/api/v1/whiskeys'
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "responds expected whiskey attributes" do
      hash_response = JSON.parse(response.body)
      expect(hash_response.length).to eq 3
      expect(hash_response[0].keys).to include('label', 'id', 'whiskey_brand_id')
    end

    it "responds filtered whiskeys" do
      get "/api/v1/whiskeys?whiskey_brand_id=2"
      hash_response = JSON.parse(response.body)
      expect(hash_response.length).to eq 2
      expect(hash_response.map{|whiskey| whiskey['id']}).to match_array [2, 3]
    end
  end
end