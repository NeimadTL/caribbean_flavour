class AddDetailsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :username, :string, default: "", null: false
    add_column :users, :firstname, :string, default: "", null: false
    add_column :users, :lastname, :string, default: "", null: false
    add_column :users, :phone_number, :string, default: "", null: false
    add_column :users, :city, :string, default: "", null: false
    add_column :users, :street, :string, default: "", null: false
    add_column :users, :additional_address_information, :string, default: "", null: true
    add_column :users, :postcode, :string, default: "", null: false
    add_column :users, :country, :string, default: "", null: false
  end
end
