class User < ApplicationRecord
  has_many :reviews

  validates :email,
            {
                format: { with: /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\z/, message: "invalid email format" },
                presence: true,
                uniqueness: { case_sensitive: false }
            }

  before_validation :normalize

  def self.create_or_update_by!(search_args = nil, attributes = {})
    user = find_or_initialize_by({ email: search_args[:email].upcase }) if (search_args && search_args[:email])
    user.update!(attributes) if user
    user
  end

  private

  def normalize
    self.email = email.upcase if email
  end
end
