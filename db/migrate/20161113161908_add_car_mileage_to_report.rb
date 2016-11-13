class AddCarMileageToReport < ActiveRecord::Migration[5.0]
  def change
    add_column :reports, :car_mileage, :integer
  end
end
