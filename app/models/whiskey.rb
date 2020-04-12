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

  scope :filter_by_label, -> (text) { where("to_tsvector(label) @@ to_tsquery('#{text.gsub(/[[:blank:]]/, '&')}')") }
  scope :filter_by_brand, -> (brands_ids) { where(whiskey_brand_id: brands_ids) }

  private

  def normalize
    self.label = label.upcase
  end

  def check_association
    #Crear asociacion con whiskey brand! o cambiar si hace falta
  end
end
