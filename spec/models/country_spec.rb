require 'rails_helper'

RSpec.describe Country, type: :model do

  it { should validate_presence_of :code }
  describe "code uniqueness validation" do
    subject { Country.create(code: "971", name: "Guadeloupe") }
    it { should validate_uniqueness_of(:code).case_insensitive }
  end
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }

  it { should have_many :cities }
  it { should have_many :shops }

end
