require 'rails_helper'

RSpec.describe Shop, type: :model do

  it { should validate_presence_of :name }

  describe "name uniqueness validation" do
    subject { Shop.create(name: 'shop', user_id: 1) }
    it { should validate_uniqueness_of(:name) }
  end

  it { should have_many :stocks }
  it { should have_many :products }

  it { should belong_to :user }

  it { should have_many :shop_delivery_options }
  it { should have_many :delivery_options }

end
