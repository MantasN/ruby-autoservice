class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.string :car_mileage
      t.string :comment
      t.references :order, index: {:unique=>true}, foreign_key: true

      t.timestamps
    end
  end
end
