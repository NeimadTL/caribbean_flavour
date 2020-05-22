require 'rails_helper'

RSpec.describe Shop, type: :model do

  it { should validate_presence_of :name }
  it { should validate_presence_of :country_code }

  describe "name uniqueness validation" do
    subject { Shop.create(name: 'shop', user_id: 1, product_category_code: 1, country_code: "971") }
    it { should validate_uniqueness_of(:name) }
  end

  it { should have_many :stocks }
  it { should have_many :products }

  it { should belong_to :user }

  it { should have_many :shop_delivery_options }
  it { should have_many :delivery_options }

  it { should belong_to :product_category }

  it { should have_many :shop_delivery_coverages }
  it { should have_many :cities }

  it { should belong_to :country }

end
