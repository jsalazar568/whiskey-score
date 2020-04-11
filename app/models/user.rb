class User < ApplicationRecord
  has_many :reviews

  validates :email,
            {
                format: { with: /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\z/, message: "invalid email format" },
                uniqueness: { case_sensitive: false }
            }

  before_validation :normalize

  private

  def normalize
    self.email = email.upcase
  end
end
