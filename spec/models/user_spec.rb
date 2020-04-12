require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'normalization' do
    it 'saves email in upcase' do
      user = User.create(email: 'user@mail.com')

      expect(user.email).to eq 'USER@MAIL.COM'
    end
  end

  describe 'uniqueness validation' do
    it 'raises error when try to save same email' do
      User.create(id: 1, email: 'user@mail.com')
      user2 = User.new(email: 'user@mail.com')

      expect{ user2.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe 'presence validation' do
    it 'raises error when try to save without a email' do
      user = User.new()

      expect{ user.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '.create_or_update_by!' do
    it 'does not save any record if no search args are passed' do
      User.create_or_update_by!()
      User.create_or_update_by!({random: 1})

      expect(User.all.count).to eq 0
    end

    it 'saves a new record if search args not found' do
      User.create_or_update_by!({email: 'user1@mail.com'}, {name: 'User 1'})
      User.create_or_update_by!({email: 'user2@mail.com'}, {name: 'User 2'})

      expect(User.all.count).to eq 2
      expect(User.first.name).to eq 'User 1'
      expect(User.last.name).to eq 'User 2'
      expect(User.first.email).to eq 'USER1@MAIL.COM'
      expect(User.last.email).to eq 'USER2@MAIL.COM'
    end

    it 'saves a new record if search args not found and update attributes are not passed' do
      User.create_or_update_by!({email: 'user1@mail.com'})

      expect(User.all.count).to eq 1
      expect(User.first.name).to eq nil
      expect(User.first.email).to eq 'USER1@MAIL.COM'
    end

    it 'saves a new record with the update attributes if search args not found' do
      User.create_or_update_by!({email: 'user1@mail.com'}, {name: 'User 1'})

      expect(User.all.count).to eq 1
      expect(User.first.name).to eq 'User 1'
      expect(User.first.email).to eq 'USER1@MAIL.COM'
    end

    it 'updates the found record with the update attributes' do
      User.create(email: 'user1@mail.com', name: 'Wrong name')
      User.create_or_update_by!({email: 'user1@mail.com'}, {name: 'User 1'})

      expect(User.all.count).to eq 1
      expect(User.first.name).to eq 'User 1'
      expect(User.first.email).to eq 'USER1@MAIL.COM'
    end
  end
end