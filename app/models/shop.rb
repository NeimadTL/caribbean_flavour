class Shop < ApplicationRecord

  validates :name, presence: true, uniqueness: true

  has_many :stocks, dependent: :destroy
  has_many :products, through: :stocks, dependent: :destroy

  belongs_to :user

  has_many :shop_delivery_options
  has_many :delivery_options, through: :shop_delivery_options

  belongs_to :product_category, foreign_key: "product_category_code"

end
