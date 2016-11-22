class AddHidePrimeToReport < ActiveRecord::Migration[5.0]
  def change
    add_column :reports, :hide_prime, :boolean
  end
end
