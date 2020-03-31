require 'rails_helper'

RSpec.describe Shop, type: :model do

  it { should validate_presence_of :name }

  describe "name uniqueness validation" do
    subject { Shop.create(name: 'shop') }
    it { should validate_uniqueness_of(:name) }
  end

  it { should have_many :stocks }
  it { should have_many :products }

end
