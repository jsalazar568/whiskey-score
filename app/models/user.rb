class User < ApplicationRecord
  has_many :reviews

  validates :email,
            {
                format: { with: /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\z/, message: "invalid email format" },
                uniqueness: { case_sensitive: false }
            }

  before_validation :normalize

  def self.create_or_update_by!(args = nil, attributes = nil)
    user = find_or_initialize_by({ email: args[:email].upcase }) if args
    user.update!(attributes) if attributes && user
    user
  end

  private

  def normalize
    self.email = email.upcase
  end
end
