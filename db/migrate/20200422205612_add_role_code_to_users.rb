class AddRoleCodeToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :role_code, :integer, default: Role::CONSUMER_ROLE_CODE, null: false
    add_index :users, :role_code
  end
end
