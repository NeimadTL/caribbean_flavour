class ProductCategory < ApplicationRecord

  self.primary_key = 'code'

  FARMING_CATEGORY_CODE = 1
  FISHING_CATEGORY_CODE = 2
  CATERING_CATEGORY_CODE = 3

  validates :code, presence: true
  validates :name, presence: true, uniqueness: true

  # TODO: both of below associations should be changed into has_many
  has_one :product
  has_one :shop, foreign_key: "product_category_code"

  def to_name
    case self.code
    when FARMING_CATEGORY_CODE
      I18n.t('farming_category')
    when FISHING_CATEGORY_CODE
      I18n.t('fishing_category')
    when CATERING_CATEGORY_CODE
      I18n.t('catering_category')
    end
  end

end
