class CreateProductions < ActiveRecord::Migration[5.0]
  def change
    create_table :productions do |t|
      t.datetime :date
      t.references :product, foreign_key: true
      t.references :line, foreign_key: true
      t.integer :begin_box00
      t.integer :begin_box01
      t.integer :begin_box02
      t.integer :begin_box03
      t.integer :begin_box04
      t.integer :begin_box05
      t.integer :begin_box06
      t.integer :begin_box07
      t.integer :begin_box08
      t.integer :begin_box09
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
      t.integer :end_box00
      t.integer :end_box01
      t.integer :end_box02
      t.integer :end_box03
      t.integer :end_box04
      t.integer :end_box05
      t.integer :end_box06
      t.integer :end_box07
      t.integer :end_box08
      t.integer :end_box09
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
      t.timestamps
    end
  end
end
