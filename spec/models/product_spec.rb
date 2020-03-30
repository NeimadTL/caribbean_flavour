require 'rails_helper'

RSpec.describe Product, type: :model do

  it { should validate_presence_of :reference }
  it { should validate_uniqueness_of :reference }
  it { should validate_presence_of :name }

end
