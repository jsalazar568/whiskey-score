class User < ApplicationRecord
  has_many :reviews

  validates :name, { presence: true }
  validates :email, { format: { with: /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\z/, message: "invalid email format" } }

  before_validation :normalize

  private

  def normalize
    self.email = email.upcase
  end
end
