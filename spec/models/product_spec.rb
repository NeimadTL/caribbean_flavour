require 'rails_helper'

RSpec.describe Product, type: :model do

  it { should validate_presence_of :reference }
  it { should validate_presence_of :name }
  it { should validate_presence_of :product_category_id}

  describe "reference uniqueness validation" do
    subject { Product.create(reference: 'yam_ref', name: 'yam', product_category_id: 1) }
    it { should validate_uniqueness_of(:reference) }
  end

  it { should belong_to :product_category }

  it { should have_many :stocks }
  it { should have_many :shops }

end
