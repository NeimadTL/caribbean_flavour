class Shop < ApplicationRecord

  validates :name, presence: true, uniqueness: true

  has_many :stocks
  has_many :products, through: :stocks

end
