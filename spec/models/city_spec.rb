require 'rails_helper'

RSpec.describe City, type: :model do

  it { should validate_presence_of :postcode }
  it { should validate_presence_of :name }
  it { should validate_presence_of :country_code }

  describe "postcode uniqueness validation" do
    subject { City.create(postcode: "97119", name: "Vieux-Habitants", country_code: "971") }
    it { should validate_uniqueness_of(:postcode).case_insensitive }
  end

  describe "name uniqueness validation" do
    subject { City.create(postcode: "97119", name: "Vieux-Habitants", country_code: "971") }
    it { should validate_uniqueness_of(:name) }
  end

  it { should belong_to :country }

end
