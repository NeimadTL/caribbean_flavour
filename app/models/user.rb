class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :phone_number, presence: true
  validates :street, presence: true

  has_one :shop
  has_one :cart
  has_many :orders
  belongs_to :role, foreign_key: "role_code"
  belongs_to :country, foreign_key: "country_code"
  belongs_to :city, foreign_key: "city_postcode"

  after_create :initialize_cart
  after_create :setup_partner_role

  private

    def initialize_cart
      self.create_cart unless self.is_partner
    end

    def setup_partner_role
      self.update(role_code: Role::PARTNER_ROLE_CODE) if self.is_partner
    end

end
