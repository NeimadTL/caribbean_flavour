require 'rails_helper'

RSpec.describe ProductCategory, type: :model do


  it { should validate_presence_of :code }
  it { should validate_presence_of :name }

  describe "name uniqueness validation" do
    subject { ProductCategory.create(code: 0, name: "Category") }
    it { should validate_uniqueness_of(:name) }
  end

  it { should have_one :product }

end
