class CreateUserExpenses < ActiveRecord::Migration[6.1]
  def change
    create_table :user_expenses do |t|
      t.references :expense, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
