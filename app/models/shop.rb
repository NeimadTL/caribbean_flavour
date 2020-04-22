class Shop < ApplicationRecord

  validates :name, presence: true, uniqueness: true
  validate :has_at_least_one_delivery_option, on: [:create, :update]

  has_many :stocks, dependent: :destroy
  has_many :products, through: :stocks, dependent: :destroy

  belongs_to :user

  has_many :shop_delivery_options
  has_many :delivery_options, through: :shop_delivery_options

  belongs_to :product_category, foreign_key: "product_category_code"

  private

    def has_at_least_one_delivery_option
      unless delivery_options.count > 0
        errors[:base] << "Please select at least one delivery option"
      end
    end

end
