class Shop < ApplicationRecord

  validates :name, presence: true, uniqueness: true
  validates :delivery_options, presence: true, unless: -> { delivery_options.count > 0 }
  validates :cities, presence: true, unless: -> { cities.count > 0 }

  has_many :stocks, dependent: :destroy
  has_many :products, through: :stocks, dependent: :destroy

  has_many :order_line_items, dependent: :destroy
  has_many :orders, through: :order_line_items, dependent: :destroy

  belongs_to :user

  has_many :shop_delivery_options, dependent: :destroy
  has_many :delivery_options, through: :shop_delivery_options, dependent: :destroy

  belongs_to :product_category, foreign_key: "product_category_code"

  has_many :shop_delivery_coverages, dependent: :destroy
  has_many :cities, through: :shop_delivery_coverages, dependent: :destroy

end
