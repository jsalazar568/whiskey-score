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

  describe "POST #create" do
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

    it "responds with erros and does not save a review if not passed the user_id and whiskey_id" do
      post '/api/v1/reviews', params: { }
      expect(Review.all.count).to eq 4
      expect(response).to have_http_status(:bad_request)

      post '/api/v1/reviews', params: { user_id: 1 }
      expect(Review.all.count).to eq 4
      expect(response).to have_http_status(:bad_request)

      post '/api/v1/reviews', params: { whiskey_id: 2 }
      expect(Review.all.count).to eq 4
      expect(response).to have_http_status(:bad_request)
    end

    it "returns http success and saves the review" do
      post '/api/v1/reviews', params: { user_id: 1, whiskey_id: 2 }

      expect(Review.all.count).to eq 5
      expect(response).to have_http_status(:success)
    end

    it "saves new review with the sent parameters" do
      post '/api/v1/reviews', params: { user_id: 1, whiskey_id: 2, title: 'A title', description: 'A description', smokiness_grade: 5 }

      hash_response = JSON.parse(response.body)
      expect(Review.all.count).to eq 5
      expect(hash_response['title']).to eq 'A title'
      expect(hash_response['description']).to eq 'A description'
      expect(hash_response['smokiness_grade']).to eq 5
      expect(hash_response['taste_grade']).to eq nil
      expect(Review.last.user_id).to eq 1
      expect(Review.last.whiskey_id).to eq 2
      expect(Review.last.title).to eq 'A title'
      expect(Review.last.description).to eq 'A description'
      expect(Review.last.smokiness_grade).to eq 5
      expect(Review.last.taste_grade).to eq nil
    end

    it "updates existing review with the sent parameters" do
      preexisting_review = Review.create(user_id: 1, whiskey_id: 2, title: 'Initial title', taste_grade: 3, smokiness_grade: 1)
      post '/api/v1/reviews', params: { user_id: 1, whiskey_id: 2, title: 'A title', description: 'A description', smokiness_grade: 5 }

      hash_response = JSON.parse(response.body)
      expect(Review.all.count).to eq 5
      expect(hash_response['title']).to eq 'A title'
      expect(hash_response['description']).to eq 'A description'
      expect(hash_response['smokiness_grade']).to eq 5
      expect(hash_response['taste_grade']).to eq 3
      expect(Review.find(preexisting_review.id).title).to eq 'A title'
      expect(Review.find(preexisting_review.id).description).to eq 'A description'
      expect(Review.find(preexisting_review.id).smokiness_grade).to eq 5
      expect(Review.find(preexisting_review.id).taste_grade).to eq 3
    end

  end
end