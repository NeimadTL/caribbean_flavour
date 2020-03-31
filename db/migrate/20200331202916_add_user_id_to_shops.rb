class AddUserIdToShops < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :user_id, :integer, null: false
    add_index :shops, :user_id
  end
end
