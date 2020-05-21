class Country < ApplicationRecord

  validates :code, presence: true, uniqueness: true, case_sensitive: false
  validates :name, presence: true, uniqueness: true

end
