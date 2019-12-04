class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.integer :code, null: false
      t.string :name, null: false
      t.integer :per_box, null: false
      t.timestamps
    end
  end
end
