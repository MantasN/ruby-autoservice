class RemoveCarMileageFromReport < ActiveRecord::Migration[5.0]
  def change
    remove_column :reports, :car_mileage, :string
  end
end
