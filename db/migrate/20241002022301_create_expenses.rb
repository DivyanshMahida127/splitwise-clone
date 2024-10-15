class CreateExpenses < ActiveRecord::Migration[6.1]
  def change
    create_table :expenses do |t|
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.references :paid_by, null: false, foreign_key: { to_table: :users }
      t.string :title
      t.text :description
      t.date :date, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false, default: 0.0

      t.timestamps
    end
  end
end
