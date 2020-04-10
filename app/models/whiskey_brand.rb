class WhiskeyBrand < ApplicationRecord
  has_many :whiskeys

  validates :name, :label, { presence: true }

  before_validation :normalize

  private

  def normalize
    self.name = brand.upcase
  end
end
