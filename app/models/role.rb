class Role < ApplicationRecord

  self.primary_key = 'code'

  ADMIN_ROLE_CODE = 1
  PARTNER_ROLE_CODE = 2
  CONSUMER_ROLE_CODE = 3

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

  has_many :users, foreign_key: "role_code"

end
