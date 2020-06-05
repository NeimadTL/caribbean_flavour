require 'rails_helper'

RSpec.describe Shop, type: :model do

  it { should validate_presence_of :name }
  it { should validate_presence_of :phone_number }
  it { should validate_presence_of :street }
  it { should validate_presence_of :minimum_delivery_price }
  it { should validate_numericality_of(:minimum_delivery_price).only_integer.is_greater_than_or_equal_to(0) }

  it { should validate_presence_of :standard_delivery_fees }
  it { should validate_numericality_of(:standard_delivery_fees).is_greater_than_or_equal_to(0.0).is_less_than_or_equal_to(2.5) }


  describe "name uniqueness validation" do
    subject { Shop.create(name: 'shop', user_id: 1, product_category_code: 1,
      country_code: "971", city_postcode: "97119")
    }
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
  it { should belong_to :city }

end
