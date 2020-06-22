class CreateVehicles < ActiveRecord::Migration[5.2]
  def change
    create_table :vehicles do |t|
      t.integer :year
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
