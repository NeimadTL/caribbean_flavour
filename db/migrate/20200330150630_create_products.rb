class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :reference, default: "", null: false
      t.string :name, default: "", null: false


      t.timestamps
    end
  end
end
