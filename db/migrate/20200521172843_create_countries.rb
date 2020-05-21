class CreateCountries < ActiveRecord::Migration[6.0]
  def change
    create_table :countries do |t|
      t.string :code, default: "", null: false
      t.string :name, default: "", null: false

      t.timestamps
    end
  end
end
