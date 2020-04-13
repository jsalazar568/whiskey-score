require 'rails_helper'

RSpec.describe Whiskey, type: :model do
  describe '.filter_by_label' do
    it 'returns only whiskeys with a label containing the text' do
      WhiskeyBrand.create(id: 1, name: 'A Whiskey Brand')
      whiskey1 = Whiskey.create(label: 'This is a label', whiskey_brand_id: 1)
      whiskey2 = Whiskey.create(label: 'This is another label', whiskey_brand_id: 1)
      Whiskey.create(label: 'Completely different text', whiskey_brand_id: 1)

      result = Whiskey.filter_by_label('this label')
      expect(result.ids).to eq [whiskey1.id, whiskey2.id]
    end
  end

  describe '.filter_by_brand' do
    it 'returns only whiskeys of the received brand ids' do
      WhiskeyBrand.create(id: 1, name: 'A Whiskey Brand')
      WhiskeyBrand.create(id: 2, name: 'Another Whiskey Brand')
      WhiskeyBrand.create(id: 3, name: 'A third Whiskey Brand')
      whiskey1 = Whiskey.create(label: 'This is a label', whiskey_brand_id: 1)
      whiskey2 = Whiskey.create(label: 'This is a label', whiskey_brand_id: 2)
      whiskey3 = Whiskey.create(label: 'This is another label', whiskey_brand_id: 2)
      Whiskey.create(whiskey_brand_id: 3, label: 'A third label')

      result = Whiskey.filter_by_brand([1])
      expect(result).to eq [whiskey1]

      result = Whiskey.filter_by_brand([1, 2])
      expect(result).to eq [whiskey1, whiskey2, whiskey3]
    end
  end

  describe 'normalization' do
    it 'saves label in upcase' do
      whiskey1 = Whiskey.create(label: 'This is a label')

      expect(whiskey1.label).to eq 'THIS IS A LABEL'
    end
  end

  describe 'label validation' do
    it 'raises error when not asigning label' do
      WhiskeyBrand.create(id: 1, name: 'A Whiskey Brand')
      whiskey1 = Whiskey.new(whiskey_brand_id: 1)

      expect{ whiskey1.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe 'uniqueness' do
    it 'saves same label for different brands' do
      WhiskeyBrand.create(id: 1, name: 'A Whiskey Brand')
      WhiskeyBrand.create(id: 2, name: 'Another Whiskey Brand')
      whiskey1 = Whiskey.create(label: 'This is a label', whiskey_brand_id: 1)
      whiskey2 = Whiskey.create(label: 'This is a label', whiskey_brand_id: 2)

      expect(Whiskey.all).to eq [whiskey1, whiskey2]
    end

    it 'raises error when try to save same label for same brand' do
      WhiskeyBrand.create(id: 1, name: 'A Whiskey Brand')
      Whiskey.create(label: 'This is a label', whiskey_brand_id: 1)
      whiskey2 = Whiskey.new(label: 'This is a label', whiskey_brand_id: 1)

      expect{ whiskey2.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end