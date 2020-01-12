class CreateProductions < ActiveRecord::Migration[5.0]
  def change
    create_table :productions do |t|
      t.datetime :date
      t.references :product, foreign_key: true
      t.references :line, foreign_key: true
      t.integer :begin_box1
      t.integer :begin_box2
      t.integer :begin_box3
      t.integer :begin_box4
      t.integer :begin_box5
      t.integer :begin_box6
      t.integer :begin_box7
      t.integer :begin_box8
      t.integer :begin_box9
      t.integer :begin_box10
      t.integer :begin_box11
      t.integer :begin_box12
      t.integer :begin_box13
      t.integer :begin_box14
      t.integer :begin_box15
      t.integer :begin_box16
      t.integer :begin_box17
      t.integer :begin_box18
      t.integer :begin_box19
      t.integer :begin_box20
      t.integer :begin_box21
      t.integer :begin_box22
      t.integer :begin_box23
      t.integer :begin_box24
      t.integer :end_box1
      t.integer :end_box2
      t.integer :end_box3
      t.integer :end_box4
      t.integer :end_box5
      t.integer :end_box6
      t.integer :end_box7
      t.integer :end_box8
      t.integer :end_box9
      t.integer :end_box10
      t.integer :end_box11
      t.integer :end_box12
      t.integer :end_box13
      t.integer :end_box14
      t.integer :end_box15
      t.integer :end_box16
      t.integer :end_box17
      t.integer :end_box18
      t.integer :end_box19
      t.integer :end_box20
      t.integer :end_box21
      t.integer :end_box22
      t.integer :end_box23
      t.integer :end_box24
      t.timestamps
    end
  end
end
