class Whiskey < ApplicationRecord
  belongs_to :whiskey_brand
  has_many :reviews

  validates :label,
            {
                presence: true,
                uniqueness: { case_sensitive: false, scope: :whiskey_brand, message: "already exists to the brand" }
            }

  before_validation :normalize
  before_save :check_association

  private

  def normalize
    self.label = label.upcase
  end

  def check_association
    #Crear asociacion con whiskey brand! o cambiar si hace falta
  end
end
