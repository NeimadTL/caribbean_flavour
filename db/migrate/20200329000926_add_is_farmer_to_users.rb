class AddIsFarmerToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_farmer, :boolean, default: false, null: false
  end
end
