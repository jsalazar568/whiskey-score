require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'enum' do
    it 'raises error when out of range' do
      User.create(id: 1, email: 'user@mail.com')
      WhiskeyBrand.create(id: 1, name: 'A Whiskey Brand')
      Whiskey.create(id: 1, label: 'This is a label', whiskey_brand_id: 1)

      review = Review.new(user_id: 1, whiskey_id: 1, taste_grade: 7)

      expect{ review.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe 'uniqueness validation' do
    it 'raises error when a user tries to save a new review for the same whiskey' do
      User.create(id: 1, email: 'user@mail.com')
      WhiskeyBrand.create(id: 1, name: 'A Whiskey Brand')
      Whiskey.create(id: 1, label: 'This is a label', whiskey_brand_id: 1)

      Review.create(id: 1, user_id: 1, whiskey_id: 1, taste_grade: 3)
      review = Review.new(id: 2, user_id: 1, whiskey_id: 1, smokiness_grade: 3)

      expect{ review.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe 'presence validation' do
    it 'raises error when try to save without a user_id and whiskey_id' do
      review = Review.new()

      expect{ review.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '.filter_by_brands' do
    it 'it gets the reviews from the whiskeys with the brand ids received' do
      User.create(id: 1, email: 'user@mail.com')
      WhiskeyBrand.create(id: 1, name: 'A Whiskey Brand')
      WhiskeyBrand.create(id: 2, name: 'Another Whiskey Brand')
      Whiskey.create(id: 1, label: 'This is a label', whiskey_brand_id: 1)
      Whiskey.create(id: 2, label: 'This is another label', whiskey_brand_id: 1)
      Whiskey.create(id: 3, label: 'A label', whiskey_brand_id: 2)

      Review.create(id: 1, user_id: 1, whiskey_id: 1, taste_grade: 3)
      Review.create(id: 2, user_id: 1, whiskey_id: 2, taste_grade: 4)
      Review.create(id: 3, user_id: 1, whiskey_id: 3, taste_grade: 5)

      expect(Review.filter_by_brands([1]).count).to eq 2
      expect(Review.filter_by_brands([1, 2]).count).to eq 3
    end
  end

  describe '.filter_by_text' do
    it 'it gets the reviews with the text in the reviews title or description or label in whiskey' do
      User.create(id: 1, email: 'user@mail.com')
      WhiskeyBrand.create(id: 1, name: 'A Whiskey Brand')
      WhiskeyBrand.create(id: 2, name: 'Another Whiskey Brand')
      Whiskey.create(id: 1, label: 'This is a label', whiskey_brand_id: 1)
      Whiskey.create(id: 2, label: 'This is another label', whiskey_brand_id: 1)
      Whiskey.create(id: 3, label: 'Completely different', whiskey_brand_id: 2)

      Review.create(id: 1, user_id: 1, whiskey_id: 1, title: 'My favorite')
      Review.create(user_id: User.last.id, whiskey_id: 2, title: 'Pisco Label', description: 'Completely delicious')
      Review.create(user_id: User.last.id, whiskey_id: 3, title: 'Black Label', description: 'Very nice')

      expect(Review.filter_by_text('completely').count).to eq 1
      expect(Review.filter_by_text('label').count).to eq 2
      expect(Review.filter_by_text('favorite').count).to eq 1
      expect(Review.filter_by_text('apple').count).to eq 0
    end
  end

  describe '.filter_by_general_text' do
    it 'it gets the reviews with the text in the reviews title or description or label in whiskey' do
      User.create(id: 1, email: 'user@mail.com')
      WhiskeyBrand.create(id: 1, name: 'A Whiskey Brand')
      WhiskeyBrand.create(id: 2, name: 'Another Whiskey Brand')
      Whiskey.create(id: 1, label: 'This is a label', whiskey_brand_id: 1)
      Whiskey.create(id: 2, label: 'This is another label', whiskey_brand_id: 1)
      Whiskey.create(id: 3, label: 'Completely different', whiskey_brand_id: 2)

      Review.create(id: 1, user_id: 1, whiskey_id: 1, title: 'My favorite')
      Review.create(user_id: User.last.id, whiskey_id: 2, title: 'Pisco Label', description: 'Completely delicious')
      Review.create(user_id: User.last.id, whiskey_id: 3, title: 'Black Label', description: 'Very nice')

      expect(Review.filter_by_general_text('completely').count).to eq 2
      expect(Review.filter_by_general_text('label').count).to eq 3
      expect(Review.filter_by_general_text('favorite').count).to eq 1
      expect(Review.filter_by_general_text('apple').count).to eq 0
    end
  end

  describe '.create_or_update_by!' do
    it 'raises error when incomplete or wrong search args' do
      expect{Review.create_or_update_by!()}.to raise_error(StandardError)
      expect{Review.create_or_update_by!({random: 1})}.to raise_error(StandardError)
      expect{Review.create_or_update_by!({user_id: 1})}.to raise_error(StandardError)
      expect{Review.create_or_update_by!({whiskey_id: 1})}.to raise_error(StandardError)
    end

    it 'raises error when broken association from search args' do
      search_args = {user_id: 1, whiskey_id: 1}
      update_attrs = {smokiness_grade: 3}

      expect{Review.create_or_update_by!(search_args, update_attrs)}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'saves a new record with the update attributes if search args not found' do
      User.create(id: 1, email: 'user@mail.com')
      WhiskeyBrand.create(id: 1, name: 'A Whiskey Brand')
      Whiskey.create(id: 1, label: 'This is a label', whiskey_brand_id: 1)
      Whiskey.create(id: 2, label: 'This is another label', whiskey_brand_id: 1)

      Review.create_or_update_by!({user_id: 1, whiskey_id: 1}, {smokiness_grade: 3})
      Review.create_or_update_by!({user_id: 1, whiskey_id: 2}, {taste_grade: 1})

      expect(Review.all.count).to eq 2
      expect(Review.first.smokiness_grade).to eq 3
      expect(Review.last.taste_grade).to eq 1
      expect(Review.first.whiskey_id).to eq 1
      expect(Review.last.whiskey_id).to eq 2
    end

    it 'saves a new record if search args not found and update attributes are not passed' do
      User.create(id: 1, email: 'user@mail.com')
      WhiskeyBrand.create(id: 1, name: 'A Whiskey Brand')
      Whiskey.create(id: 1, label: 'This is a label', whiskey_brand_id: 1)

      Review.create_or_update_by!({user_id: 1, whiskey_id: 1})

      expect(Review.all.count).to eq 1
      expect(Review.first.user_id).to eq 1
      expect(Review.first.description).to eq nil
      expect(Review.first.smokiness_grade).to eq nil
    end

    it 'updates the found record with the update attributes' do
      User.create(id: 1, email: 'user@mail.com')
      WhiskeyBrand.create(id: 1, name: 'A Whiskey Brand')
      Whiskey.create(id: 1, label: 'This is a label', whiskey_brand_id: 1)

      Review.create(user_id: 1, whiskey_id: 1, taste_grade: 3)
      Review.create_or_update_by!({user_id: 1, whiskey_id: 1}, {taste_grade: 1, smokiness_grade: 3})


      expect(Review.all.count).to eq 1
      expect(Review.first.user_id).to eq 1
      expect(Review.first.description).to eq nil
      expect(Review.first.taste_grade).to eq 1
      expect(Review.first.smokiness_grade).to eq 3
    end
  end
end