require 'rails_helper'

RSpec.describe User, type: :model do

  it { should validate_presence_of :username }
  describe "username uniqueness validation" do
    subject do
      User.create!(username: "dummyuser", firstname: "dummy", lastname: "dummylastname",
      email: "dummy@gmail.com", phone_number: "0394274839", street: "street",
      additional_address_information: "additional address", country_code: "971",
      city_postcode: "97119", is_partner: false, role_code: Role::ADMIN_ROLE_CODE,
      password: "12345678", password_confirmation: "12345678")
    end
    it { should validate_uniqueness_of(:username) }
  end
  it { should validate_presence_of :firstname }
  it { should validate_presence_of :lastname }
  it { should validate_presence_of :phone_number }
  it { should validate_presence_of :street }

  it { should have_one :shop }
  it { should have_one :cart }
  it { should have_many :orders }
  it { should belong_to :role }
  it { should belong_to :country }
  it { should belong_to :city }

end
