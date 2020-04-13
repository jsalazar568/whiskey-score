require 'rails_helper'
require 'faker'

RSpec.describe Api::V1::ReviewsController do
  describe "GET #index" do
    before do
      User.create(id: 1, email: 'user@mail.com')
      User.create(id: 2, email: 'user2@mail.com')
      WhiskeyBrand.create(id: 1, name: 'A Whiskey Brand')
      WhiskeyBrand.create(id: 2, name: 'Another Whiskey Brand')
      Whiskey.create(id: 1, label: 'This is a label', whiskey_brand_id: 1)
      Whiskey.create(id: 2, label: 'This is another label', whiskey_brand_id: 1)
      Whiskey.create(id: 3, label: 'Completely different', whiskey_brand_id: 2)

      Review.create(id: 1, user_id: 1, whiskey_id: 1, title: 'My favorite', taste_grade: 3)
      Review.create(user_id: 2, whiskey_id: 1, title: 'My favorite', taste_grade: 3)
      Review.create(user_id: 2, whiskey_id: 2, title: 'Pisco Label', description: 'Completely delicious', taste_grade: 3)
      Review.create(user_id: 2, whiskey_id: 3, title: 'Black Label', description: 'Very nice', taste_grade: 4)
    end

    it "returns error when not receving user" do
      expect{get '/api/v1/reviews'}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "returns http success" do
      get '/api/v1/reviews?user_id=1'

      expect(response).to have_http_status(:success)
    end

    it "responds expected reviews attributes" do
      get '/api/v1/reviews?user_id=1'

      hash_response = JSON.parse(response.body)
      expect(hash_response['reviews'].length).to eq 1
      expect(hash_response['reviews'][0].keys).to include('id', 'title', 'description', 'taste_grade', 'color_grade', 'smokiness_grade')
    end

    it "filters by user" do
      get '/api/v1/reviews?user_id=2'

      hash_response = JSON.parse(response.body)
      expect(hash_response['reviews'].length).to eq 3
      expect(hash_response['reviews'][0].keys).to include('id', 'title', 'description', 'taste_grade', 'color_grade', 'smokiness_grade')
    end

    it "responds reviews filtered by text and user" do
      get '/api/v1/reviews?user_id=1&text_search=label'

      hash_response = JSON.parse(response.body)
      expect(hash_response['reviews'].length).to eq 1

      get '/api/v1/reviews?user_id=2&text_search=label'

      hash_response = JSON.parse(response.body)
      expect(hash_response['reviews'].length).to eq 3

      get '/api/v1/reviews?user_id=2&text_search=completely'

      hash_response = JSON.parse(response.body)
      expect(hash_response['reviews'].length).to eq 2

      get '/api/v1/reviews?user_id=2&text_search=favorite'

      hash_response = JSON.parse(response.body)
      expect(hash_response['reviews'].length).to eq 1

      get '/api/v1/reviews?user_id=1&text_search=favorite'

      hash_response = JSON.parse(response.body)
      expect(hash_response['reviews'].length).to eq 1

      get '/api/v1/reviews?user_id=2&text_search=apple'

      hash_response = JSON.parse(response.body)
      expect(hash_response['reviews'].length).to eq 0
    end

    it "responds reviews filtered by grade and user" do
      get '/api/v1/reviews?user_id=1&taste_grade=3'

      hash_response = JSON.parse(response.body)
      expect(hash_response['reviews'].length).to eq 1

      get '/api/v1/reviews?user_id=2&taste_grade=3'

      hash_response = JSON.parse(response.body)
      expect(hash_response['reviews'].length).to eq 2

      get '/api/v1/reviews?user_id=2&taste_grade=3&text_search=label'

      hash_response = JSON.parse(response.body)
      expect(hash_response['reviews'].length).to eq 2

      get '/api/v1/reviews?user_id=2&taste_grade=3&text_search=favorite'

      hash_response = JSON.parse(response.body)
      expect(hash_response['reviews'].length).to eq 1
    end

    it "responds reviews filtered by whiskey brand and user" do
      get '/api/v1/reviews?user_id=1&whiskey_brand_ids[]=2'

      hash_response = JSON.parse(response.body)
      expect(hash_response['reviews'].length).to eq 0

      get '/api/v1/reviews?user_id=2&whiskey_brand_ids[]=1'

      hash_response = JSON.parse(response.body)
      expect(hash_response['reviews'].length).to eq 2

      get '/api/v1/reviews?user_id=2&whiskey_brand_ids[]=1&whiskey_brand_ids[]=2'

      hash_response = JSON.parse(response.body)
      expect(hash_response['reviews'].length).to eq 3

      get '/api/v1/reviews?user_id=2&whiskey_brand_ids[]=1&text_search=favorite'

      hash_response = JSON.parse(response.body)
      expect(hash_response['reviews'].length).to eq 1

      get '/api/v1/reviews?user_id=2&whiskey_brand_ids[]=1&text_search=favorite&taste_grade=3'

      hash_response = JSON.parse(response.body)
      expect(hash_response['reviews'].length).to eq 1

      get '/api/v1/reviews?user_id=2&whiskey_brand_ids[]=1&text_search=favorite&taste_grade=4'

      hash_response = JSON.parse(response.body)
      expect(hash_response['reviews'].length).to eq 0

      get '/api/v1/reviews?user_id=2&whiskey_brand_ids[]=1&text_search=favorite&color_grade=4'

      hash_response = JSON.parse(response.body)
      expect(hash_response['reviews'].length).to eq 0
    end
  end
end