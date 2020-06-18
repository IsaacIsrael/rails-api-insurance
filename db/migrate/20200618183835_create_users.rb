class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :age, null: false, default: 0
      t.integer :dependents, null: false, default: 0
      t.integer :income, null: false, default: 0
      t.string :marital_status, null: false, default: 0
      t.integer :risk_questions, null: false, array: true, default: []

      t.timestamps
    end
  end
end
