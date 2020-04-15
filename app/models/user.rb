class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :phone_number, presence: true
  validates :city, presence: true
  validates :street, presence: true
  validates :postcode, presence: true
  validates :country, presence: true

  has_one :shop
  has_one :cart

  after_create :initialize_cart

  private

    def initialize_cart
      self.create_cart unless self.is_partner
    end

end
