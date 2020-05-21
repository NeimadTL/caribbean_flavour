class Country < ApplicationRecord

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true

end
