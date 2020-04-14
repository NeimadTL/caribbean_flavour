require 'rails_helper'

RSpec.describe User, type: :model do

  it { should validate_presence_of :username }
  it { should validate_uniqueness_of :username }
  it { should validate_presence_of :firstname }
  it { should validate_presence_of :lastname }
  it { should validate_presence_of :phone_number }
  it { should validate_presence_of :city }
  it { should validate_presence_of :street }
  it { should validate_presence_of :postcode }
  it { should validate_presence_of :country }

  it { should have_one :shop }
  it { should have_one :cart }

end
