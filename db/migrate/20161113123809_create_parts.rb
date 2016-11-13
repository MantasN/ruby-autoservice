class CreateParts < ActiveRecord::Migration[5.0]
  def change
    create_table :parts do |t|
      t.string :title
      t.integer :quantity
      t.decimal :prime_price
      t.decimal :client_price
      t.references :report, foreign_key: true

      t.timestamps
    end
  end
end
