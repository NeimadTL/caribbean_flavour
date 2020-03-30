class RenameIsFarmerToIsPartnerOnUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :is_farmer, :is_partner
  end
end
