require 'rails_helper'

RSpec.describe Whiskey, type: :model do
  describe 'normalization' do
    it 'saves name in upcase' do
      whiskey_brand = WhiskeyBrand.create(name: 'A whiskey brand')

      expect(whiskey_brand.name).to eq 'A WHISKEY BRAND'
    end
  end

  describe 'uniqueness validation' do
    it 'raises error when try to save same name' do
      WhiskeyBrand.create(id: 1, name: 'A Whiskey Brand')
      whiskey_brand2 = WhiskeyBrand.new(name: 'A Whiskey Brand')

      expect{ whiskey_brand2.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe 'presence validation' do
    it 'raises error when try to save without a name' do
      whiskey_brand = WhiskeyBrand.new()

      expect{ whiskey_brand.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end