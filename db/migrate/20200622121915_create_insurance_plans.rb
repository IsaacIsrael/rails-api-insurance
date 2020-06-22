class CreateInsurancePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :insurance_plans do |t|
      t.string :auto
      t.string :disability
      t.string :home
      t.string :life
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
