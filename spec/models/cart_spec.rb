require 'rails_helper'

RSpec.describe Cart, type: :model do

  it { should validate_presence_of :user_id }
  
  it { should have_many :line_items }
  it { should belong_to :user }

end
