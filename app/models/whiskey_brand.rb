class WhiskeyBrand < ApplicationRecord
  has_many :whiskeys

  validates :name, { presence: true, uniqueness: { case_sensitive: false } }

  before_validation :normalize

  private

  def normalize
    self.name = name.upcase
  end
end
