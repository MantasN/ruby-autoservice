class CreateDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :details do |t|
      t.string :reason
      t.string :car
      t.string :owner
      t.references :order, index: {:unique=>true}, foreign_key: true

      t.timestamps
    end
  end
end
